#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/qa-branch-switch.log"
BACKUP_BRANCH=""
START_TIME=$(date +%s)

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to print colored messages with logging
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] STEP: $1" >> "$LOG_FILE"
}

print_debug() {
    if [ "${DEBUG:-false}" = "true" ]; then
        echo -e "${PURPLE}🐛 $1${NC}"
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEBUG: $1" >> "$LOG_FILE"
}

# Error handling function
handle_error() {
    local exit_code=$?
    local line_number=$1
    print_error "Script failed at line $line_number with exit code $exit_code"
    print_error "Check log file: $LOG_FILE"

    if [ -n "$BACKUP_BRANCH" ]; then
        print_warning "Attempting to restore original branch: $BACKUP_BRANCH"
        git checkout "$BACKUP_BRANCH" 2>/dev/null || print_error "Failed to restore original branch"
    fi

    exit $exit_code
}

# Set up error trap
trap 'handle_error $LINENO' ERR

# Function to clean Metro ports
clean_metro_ports() {
    local ports=(8081 8082 19000 19001 19002)  # Common Metro and Expo ports

    print_info "Cleaning Metro/Expo ports..."
    for port in "${ports[@]}"; do
        local pids=$(lsof -ti:$port 2>/dev/null)
        if [ -n "$pids" ]; then
            print_debug "Killing processes on port $port: $pids"
            echo $pids | xargs kill -9 2>/dev/null || true
        fi
    done

    # Also kill any node processes that might be Metro
    pkill -f "react-native start" 2>/dev/null || true
    pkill -f "expo start" 2>/dev/null || true
    pkill -f "metro" 2>/dev/null || true

    print_success "Metro/Expo ports cleaned"
}

# Function to check if command exists and is working
check_command() {
    local cmd=$1
    local description=$2

    if ! command -v "$cmd" &> /dev/null; then
        print_error "$description ($cmd) is not installed or not in PATH"
        return 1
    fi

    # Test the command works
    case "$cmd" in
        "node")
            node --version &> /dev/null || { print_error "Node.js is not working properly"; return 1; }
            ;;
        "yarn")
            yarn --version &> /dev/null || { print_error "Yarn is not working properly"; return 1; }
            ;;
        "npm")
            npm --version &> /dev/null || { print_error "npm is not working properly"; return 1; }
            ;;
        "git")
            git --version &> /dev/null || { print_error "Git is not working properly"; return 1; }
            ;;
        "expo")
            expo --version &> /dev/null || { print_error "Expo CLI is not working properly"; return 1; }
            ;;
    esac

    print_debug "$description ($cmd) is available and working"
    return 0
}

# Function to test GitHub package registry authentication
test_github_auth() {
    print_debug "Testing GitHub package registry authentication..."

    # Test authentication by trying to get user info from GitHub registry
    local auth_test_output
    auth_test_output=$(npm whoami --registry=https://npm.pkg.github.com 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        print_debug "GitHub authentication test passed for user: $(echo "$auth_test_output" | head -1)"
        return 0
    else
        print_debug "GitHub authentication test failed with exit code: $exit_code"
        print_debug "npm whoami output: $auth_test_output"

        # Check if it's specifically an authentication error
        if echo "$auth_test_output" | grep -q "401\|Unauthorized\|authentication"; then
            print_debug "Authentication error detected (401/Unauthorized)"
        elif echo "$auth_test_output" | grep -q "ENOTFOUND\|network"; then
            print_debug "Network error detected - treating as auth failure"
        fi

        return 1
    fi
}

# Function to validate environment
validate_environment() {
    print_step "Validating environment..."

    # Check if we're in a React Native project
    if [ ! -f "$PROJECT_ROOT/package.json" ]; then
        print_error "Not in a React Native project root (package.json not found)"
        exit 1
    fi

    # Check if it's an Expo project
    if [ ! -f "$PROJECT_ROOT/app.json" ] && [ ! -f "$PROJECT_ROOT/app.config.js" ] && [ ! -f "$PROJECT_ROOT/app.config.ts" ]; then
        print_error "Not in an Expo project (app.json/app.config not found)"
        exit 1
    fi

    # Check required commands
    local required_commands=(
        "git:Git"
        "node:Node.js"
    )

    # Determine package manager
    if [ -f "$PROJECT_ROOT/yarn.lock" ]; then
        required_commands+=("yarn:Yarn")
        PACKAGE_MANAGER="yarn"
    elif [ -f "$PROJECT_ROOT/package-lock.json" ]; then
        required_commands+=("npm:npm")
        PACKAGE_MANAGER="npm"
    else
        print_error "No lock file found! Please ensure yarn.lock or package-lock.json exists."
        exit 1
    fi

    # Check if Expo CLI is available
    if check_command "expo" "Expo CLI"; then
        HAS_EXPO_CLI=true
    else
        HAS_EXPO_CLI=false
        print_warning "Expo CLI not found. Some features may not work."
    fi

    # Validate all required commands
    for cmd_desc in "${required_commands[@]}"; do
        IFS=':' read -r cmd desc <<< "$cmd_desc"
        if ! check_command "$cmd" "$desc"; then
            exit 1
        fi
    done

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi

    # Check git status
    if ! git status > /dev/null 2>&1; then
        print_error "Git repository is in a bad state"
        exit 1
    fi

    # Check for GitHub package registry authentication if needed
    if grep -q "npm.pkg.github.com" "$PROJECT_ROOT/.npmrc" 2>/dev/null || grep -q "@.*:registry=.*npm.pkg.github.com" "$PROJECT_ROOT/.npmrc" 2>/dev/null; then
        print_info "GitHub packages detected, checking authentication..."

        if test_github_auth; then
            print_success "GitHub authentication test passed!"

            # Show which auth methods are configured
            if [ -n "${GITHUB_TOKEN:-}" ]; then
                print_info "  ✓ GITHUB_TOKEN environment variable"
            fi
            if [ -f "$PROJECT_ROOT/.npmrc" ] && grep -q "_authToken" "$PROJECT_ROOT/.npmrc" 2>/dev/null; then
                print_info "  ✓ project .npmrc file"
            fi
            if [ -f "$HOME/.npmrc" ] && grep -q "npm.pkg.github.com" "$HOME/.npmrc" 2>/dev/null; then
                print_info "  ✓ ~/.npmrc file"
            fi
        else
            print_error "GitHub packages detected but authentication failed!"
            print_error "This will cause dependency installation to fail"
            print_info ""
            print_info "To fix this, you can:"
            print_info "1. Set GITHUB_TOKEN environment variable:"
            print_info "   export GITHUB_TOKEN=your_github_token"
            print_info ""
            print_info "2. Configure ~/.npmrc:"
            print_info "   echo '//npm.pkg.github.com/:_authToken=YOUR_TOKEN' >> ~/.npmrc"
            print_info ""
            print_info "3. Login to GitHub package registry:"
            print_info "   npm login --registry=https://npm.pkg.github.com"
            print_info ""
            print_info "4. Update project .npmrc with a valid token"
            exit 1
        fi
    fi

    print_success "Environment validation passed"
}

# Function to backup current state
backup_current_state() {
    print_step "Backing up current state..."

    BACKUP_BRANCH=$(git branch --show-current)
    print_debug "Current branch backed up: $BACKUP_BRANCH"

    # Create a temporary commit if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        print_info "Creating temporary backup of uncommitted changes..."
        git add -A
        git commit -m "TEMP: Backup before branch switch - $(date)" || {
            print_warning "Could not create backup commit"
        }
    fi

    print_success "Current state backed up"
}

# Function to clean React Native and Gradle specific caches
clean_react_native_gradle_caches() {
    print_step "Cleaning React Native and Gradle caches..."

    # Clean Gradle daemon processes
    print_info "Stopping Gradle daemons..."
    ./android/gradlew --stop 2>/dev/null || gradle --stop 2>/dev/null || true

    # Clean React Native specific caches
    print_info "Cleaning React Native caches..."
    rm -rf "$HOME/.gradle/caches/transforms-*" 2>/dev/null || true
    rm -rf "$HOME/.gradle/caches/*/kotlin-dsl" 2>/dev/null || true
    rm -rf "$HOME/.gradle/caches/*/scripts" 2>/dev/null || true

    # Clean Android build outputs completely
    print_info "Cleaning Android build outputs..."
    rm -rf "$PROJECT_ROOT/android/build" 2>/dev/null || true
    rm -rf "$PROJECT_ROOT/android/app/build" 2>/dev/null || true
    rm -rf "$PROJECT_ROOT/android/.gradle" 2>/dev/null || true

    print_success "React Native and Gradle caches cleaned"
}

# Function to thoroughly clean all caches
deep_clean_caches() {
    print_step "Performing deep cache cleaning..."

    # Clean Metro/Expo ports and processes
    clean_metro_ports

    # Clean Metro cache thoroughly
    print_info "Cleaning Metro cache..."
    rm -rf "$HOME/.metro" 2>/dev/null || true
    rm -rf /tmp/react-native-* 2>/dev/null || true
    rm -rf /tmp/haste-map-* 2>/dev/null || true
    rm -rf /tmp/metro-cache-* 2>/dev/null || true
    rm -rf /tmp/metro-* 2>/dev/null || true

    # Clean Watchman
    if command -v watchman &> /dev/null; then
        print_info "Cleaning Watchman cache..."
        watchman watch-del-all 2>/dev/null || true
        watchman shutdown-server 2>/dev/null || true
    fi

    # Clean package manager caches
    print_info "Cleaning package manager cache..."
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn cache clean 2>/dev/null || true
    elif [ "$PACKAGE_MANAGER" = "npm" ]; then
        npm cache clean --force 2>/dev/null || true
    fi

    # Clean Expo caches
    if [ "$HAS_EXPO_CLI" = true ]; then
        print_info "Cleaning Expo cache..."
        expo r -c 2>/dev/null || true
    fi

    # Clean global caches
    rm -rf "$HOME/.expo" 2>/dev/null || true
    rm -rf "$HOME/.gradle/caches" 2>/dev/null || true
    rm -rf "$HOME/.gradle/wrapper" 2>/dev/null || true

    # Clean Android-specific caches
    print_info "Cleaning Android/Gradle caches..."
    rm -rf "$PROJECT_ROOT/android/.gradle" 2>/dev/null || true
    rm -rf "$PROJECT_ROOT/android/build" 2>/dev/null || true
    rm -rf "$PROJECT_ROOT/android/app/build" 2>/dev/null || true

    # Clean project-specific caches
    rm -rf "$PROJECT_ROOT/.expo" 2>/dev/null || true
    rm -rf "$PROJECT_ROOT/node_modules/.cache" 2>/dev/null || true

    print_success "Deep cache cleaning completed"
}

# Function to verify dependencies after installation
verify_dependencies() {
    print_step "Verifying dependencies..."

    # Check if node_modules exists and has content
    if [ ! -d "$PROJECT_ROOT/node_modules" ] || [ -z "$(ls -A "$PROJECT_ROOT/node_modules" 2>/dev/null)" ]; then
        print_error "node_modules is missing or empty"
        return 1
    fi

    # Check if package.json dependencies are satisfied
    print_info "Checking critical dependencies..."
    local critical_deps=("react" "react-native" "expo")

    for dep in "${critical_deps[@]}"; do
        if [ -d "$PROJECT_ROOT/node_modules/$dep" ]; then
            print_debug "✓ $dep is installed"
        else
            print_warning "⚠ $dep might be missing"
        fi
    done

    # Verify package manager can read dependencies
    if ! $PACKAGE_MANAGER list --depth=0 > /dev/null 2>&1; then
        print_warning "Package manager reports dependency issues"
        return 1
    fi

    print_success "Dependencies verification passed"
    return 0
}

# Function to verify native projects
verify_native_projects() {
    print_step "Verifying native projects..."

    local ios_valid=false
    local android_valid=false

    # Check iOS
    if [ -d "$PROJECT_ROOT/ios" ]; then
        if [ -f "$PROJECT_ROOT/ios/Podfile" ] && [ -d "$PROJECT_ROOT/ios/Pods" ] && [ -f "$PROJECT_ROOT/ios/Podfile.lock" ]; then
            ios_valid=true
            print_debug "iOS project is valid"
        else
            print_warning "iOS project exists but CocoaPods not properly installed"
        fi
    else
        print_warning "iOS project directory missing"
    fi

    # Check Android
    if [ -d "$PROJECT_ROOT/android" ]; then
        if [ -f "$PROJECT_ROOT/android/build.gradle" ] && [ -f "$PROJECT_ROOT/android/app/build.gradle" ]; then
            android_valid=true
            print_debug "Android project is valid"
        else
            print_warning "Android project exists but Gradle files missing"
        fi
    else
        print_warning "Android project directory missing"
    fi

    if [ "$ios_valid" = true ] && [ "$android_valid" = true ]; then
        print_success "Native projects verification passed"
        return 0
    else
        print_error "Native projects verification failed"
        return 1
    fi
}

# Function to install iOS dependencies with retry
install_ios_dependencies() {
    print_step "Installing iOS dependencies..."

    if [ ! -d "$PROJECT_ROOT/ios" ]; then
        print_warning "iOS directory not found, skipping CocoaPods installation"
        return 0
    fi

    # Set Ruby environment
    export RUBY_TCP_NO_FAST_FALLBACK=1

    local max_retries=3
    local retry=0

    while [ $retry -lt $max_retries ]; do
        print_info "Installing CocoaPods dependencies (attempt $((retry + 1))/$max_retries)..."

        cd "$PROJECT_ROOT/ios"

        if command -v bundle &> /dev/null; then
            if bundle install && bundle exec pod install --repo-update; then
                cd "$PROJECT_ROOT"
                print_success "CocoaPods dependencies installed successfully"
                return 0
            fi
        elif command -v pod &> /dev/null; then
            if pod install --repo-update; then
                cd "$PROJECT_ROOT"
                print_success "CocoaPods dependencies installed successfully"
                return 0
            fi
        else
            cd "$PROJECT_ROOT"
            print_error "Neither bundle nor pod command found!"
            return 1
        fi

        cd "$PROJECT_ROOT"
        retry=$((retry + 1))
        if [ $retry -lt $max_retries ]; then
            print_warning "CocoaPods installation failed, retrying in 5 seconds..."
            sleep 5
        fi
    done

    print_error "Failed to install CocoaPods dependencies after $max_retries attempts"
    return 1
}

# Function to run comprehensive post-switch validation
post_switch_validation() {
    print_step "Running comprehensive post-switch validation..."

    local validation_failed=false

    # Validate package.json
    if ! node -e "JSON.parse(require('fs').readFileSync('package.json', 'utf8'))" 2>/dev/null; then
        print_error "package.json is invalid"
        validation_failed=true
    fi

    # Validate dependencies
    if ! verify_dependencies; then
        validation_failed=true
    fi

    # Validate native projects
    if ! verify_native_projects; then
        validation_failed=true
    fi

    # Test Metro bundler can start (dry run) - make this non-critical
    print_info "Testing Metro bundler startup..."
    if command -v npx &> /dev/null; then
        # Clean ports before testing Metro
        print_debug "Cleaning ports before Metro test..."
        clean_metro_ports

        # Try to start Metro with a longer timeout and better error handling
        timeout 15s npx react-native start --reset-cache --port=0 > /tmp/metro-test.log 2>&1 &
        local metro_pid=$!
        sleep 5
        if kill -0 $metro_pid 2>/dev/null; then
            kill $metro_pid 2>/dev/null || true
            print_success "Metro bundler test passed"
        else
            print_warning "Metro bundler test failed (this may not be critical)"
            print_debug "Metro test log: $(cat /tmp/metro-test.log 2>/dev/null | head -3)"
        fi
        rm -f /tmp/metro-test.log 2>/dev/null || true
    else
        print_warning "npx not available, skipping Metro bundler test"
    fi

    if [ "$validation_failed" = true ]; then
        print_error "Post-switch validation failed"
        return 1
    fi

    print_success "Post-switch validation passed"
    print_info "✓ package.json is valid"
    print_info "✓ Dependencies are installed correctly"
    print_info "✓ Native projects (iOS/Android) are properly configured"
    print_info "✓ CocoaPods dependencies are installed"
    return 0
}

# Function to show help
show_help() {
    echo "QA Branch Switch Tool"
    echo ""
    echo "Usage: $0 [OPTIONS] <branch-name>"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -v, --verbose       Enable verbose output"
    echo "  -d, --debug         Enable debug output"
    echo "  --dry-run           Show what would be done without executing"
    echo "  --skip-validation   Skip environment validation (not recommended)"
    echo "  --clean-ports       Only clean Metro/Expo ports and exit"
    echo "  --check-auth        Check GitHub package registry authentication"
    echo ""
    echo "Examples:"
    echo "  $0 feature/new-login"
    echo "  $0 --debug develop"
    echo "  $0 --verbose hotfix/payment-bug"
    echo "  $0 --clean-ports                    # Just clean Metro/Expo ports"
    echo ""
    echo "This script will:"
    echo "  1. Validate environment and dependencies"
    echo "  2. Backup current state"
    echo "  3. Switch to the specified branch"
    echo "  4. Deep clean all caches"
    echo "  5. Reinstall dependencies"
    echo "  6. Rebuild native projects"
    echo "  7. Verify everything is working"
    echo ""
    echo "Log file: $LOG_FILE"
    echo ""
}

# Parse command line arguments
VERBOSE=false
DEBUG=false
DRY_RUN=false
SKIP_VALIDATION=false
CLEAN_PORTS_ONLY=false
CHECK_AUTH_ONLY=false
TARGET_BRANCH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--debug)
            DEBUG=true
            VERBOSE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-validation)
            SKIP_VALIDATION=true
            shift
            ;;
        --clean-ports)
            CLEAN_PORTS_ONLY=true
            shift
            ;;
        --check-auth)
            CHECK_AUTH_ONLY=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$TARGET_BRANCH" ]; then
                TARGET_BRANCH="$1"
            else
                print_error "Multiple branch names provided"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Handle clean-ports-only option
if [ "$CLEAN_PORTS_ONLY" = true ]; then
    echo "Cleaning Metro/Expo Ports Only"
    echo "================================="
    clean_metro_ports
    print_success "Port cleaning completed!"
    exit 0
fi

# Handle check-auth-only option
if [ "$CHECK_AUTH_ONLY" = true ]; then
    echo "GitHub Package Registry Authentication Check"
    echo "==============================================="

    cd "$PROJECT_ROOT"

    if ! grep -q "npm.pkg.github.com" .npmrc 2>/dev/null && ! grep -q "@.*:registry=.*npm.pkg.github.com" .npmrc 2>/dev/null; then
        print_info "No GitHub packages detected in .npmrc"
        print_success "No authentication needed!"
        exit 0
    fi

    print_info "GitHub packages detected, checking authentication..."

    if test_github_auth; then
        print_success "GitHub authentication test passed!"

        # Show which auth methods are configured
        auth_methods=()
        if [ -n "${GITHUB_TOKEN:-}" ]; then
            auth_methods+=("GITHUB_TOKEN environment variable")
        fi
        if [ -f ".npmrc" ] && grep -q "_authToken" ".npmrc" 2>/dev/null; then
            auth_methods+=("project .npmrc file")
        fi
        if [ -f "$HOME/.npmrc" ] && grep -q "npm.pkg.github.com" "$HOME/.npmrc" 2>/dev/null; then
            auth_methods+=("~/.npmrc file")
        fi

        if [ ${#auth_methods[@]} -gt 0 ]; then
            print_success "Authentication configured via:"
            for method in "${auth_methods[@]}"; do
                print_info "  ✓ $method"
            done
        fi
        exit 0
    else
        print_error "GitHub authentication test failed!"
        print_error "Token is invalid, expired, or has insufficient permissions"
        print_info ""
        print_info "To fix this, you can:"
        print_info "1. Set GITHUB_TOKEN environment variable with a valid token:"
        print_info "   export GITHUB_TOKEN=your_github_token"
        print_info ""
        print_info "2. Update project .npmrc with a valid token:"
        print_info "   //npm.pkg.github.com/:_authToken=YOUR_VALID_TOKEN"
        print_info ""
        print_info "3. Configure ~/.npmrc:"
        print_info "   echo '//npm.pkg.github.com/:_authToken=YOUR_TOKEN' >> ~/.npmrc"
        print_info ""
        print_info "4. Login to GitHub package registry:"
        print_info "   npm login --registry=https://npm.pkg.github.com"
        exit 1
    fi
fi

# Check if branch name is provided
if [ -z "$TARGET_BRANCH" ]; then
    print_error "Branch name is required!"
    show_help
    exit 1
fi

# Initialize log file
echo "=== QA Branch Switch Log - $(date) ===" > "$LOG_FILE"

# Main execution starts here
cd "$PROJECT_ROOT"

echo "QA Branch Switch Tool"
echo "============================================"
print_info "Target branch: $TARGET_BRANCH"
print_info "Log file: $LOG_FILE"

if [ "$DRY_RUN" = true ]; then
    print_warning "DRY RUN MODE - No changes will be made"
fi

echo ""

# Step 1: Environment validation
if [ "$SKIP_VALIDATION" = false ]; then
    validate_environment
else
    print_warning "Skipping environment validation (not recommended)"
fi

# Step 2: Check if target branch exists
print_step "Checking if branch '$TARGET_BRANCH' exists..."
if ! git show-ref --verify --quiet refs/heads/$TARGET_BRANCH && ! git show-ref --verify --quiet refs/remotes/origin/$TARGET_BRANCH; then
    print_error "Branch '$TARGET_BRANCH' does not exist locally or remotely!"
    print_info "Available branches:"
    git branch -a | grep -v HEAD
    exit 1
fi
print_success "Branch '$TARGET_BRANCH' found"

# Step 3: Backup current state
if [ "$DRY_RUN" = false ]; then
    backup_current_state
fi

# Step 4: Check for uncommitted changes
print_step "Checking for uncommitted changes..."
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes!"
    if [ "$DRY_RUN" = false ]; then
        print_info "Current changes:"
        git status --porcelain
        echo ""
        read -p "Do you want to continue? Changes will be backed up! (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Aborted by user"
            exit 0
        fi
    fi
fi

# Step 5: Switch branch
if [ "$DRY_RUN" = false ]; then
    echo ""
    print_step "Switching to branch '$TARGET_BRANCH'..."

    # Fetch latest changes
    print_info "Fetching latest changes..."
    git fetch origin

    # Reset any local changes
    git reset --hard HEAD
    git clean -fd

    # Switch to target branch
    if git show-ref --verify --quiet refs/heads/$TARGET_BRANCH; then
        git checkout $TARGET_BRANCH
        git pull origin $TARGET_BRANCH 2>/dev/null || print_warning "Could not pull from origin (branch might be local only)"
    else
        git checkout -b $TARGET_BRANCH origin/$TARGET_BRANCH
    fi

    print_success "Switched to branch '$TARGET_BRANCH'"
fi

# Step 6: Deep clean
if [ "$DRY_RUN" = false ]; then
    clean_react_native_gradle_caches
    deep_clean_caches

    print_step "Cleaning project files..."
    rm -rf node_modules .expo vendor 2>/dev/null || true
    rm -rf android/build android/app/build android/.gradle 2>/dev/null || true
    rm -rf ios/build ios/Pods ios/Podfile.lock 2>/dev/null || true
    print_success "Project files cleaned"
fi

# Step 7: Install dependencies
if [ "$DRY_RUN" = false ]; then
    echo ""
    print_step "Installing dependencies..."

    if grep -q "npm.pkg.github.com" .npmrc 2>/dev/null || grep -q "@.*:registry=.*npm.pkg.github.com" .npmrc 2>/dev/null; then
        print_info "Detected GitHub packages, checking authentication..."

        if [ -z "${NPM_TOKEN:-}" ] && [ -z "${GITHUB_TOKEN:-}" ]; then
            if [ ! -f "$HOME/.npmrc" ] || ! grep -q "npm.pkg.github.com" "$HOME/.npmrc" 2>/dev/null; then
                print_warning "GitHub packages detected but no authentication found"
                print_info "You may need to:"
                print_info "  1. Set NPM_TOKEN or GITHUB_TOKEN environment variable"
                print_info "  2. Configure ~/.npmrc with GitHub package registry token"
                print_info "  3. Run 'npm login --registry=https://npm.pkg.github.com'"
            fi
        fi
    fi

    if ! ./scripts/install-dependencies.sh; then
        print_error "Dependencies installation failed"

        if grep -q "401 Unauthorized" "$LOG_FILE" 2>/dev/null; then
            print_error "GitHub package authentication failed"
            print_info "Please configure GitHub package access and try again"
        fi

        exit 1
    fi

    print_success "Dependencies installed"

    if ! verify_dependencies; then
        print_error "Dependency verification failed"
        exit 1
    fi
fi

# Step 8: Rebuild native projects
if [ "$DRY_RUN" = false ]; then
    echo ""
    print_step "Rebuilding native projects..."
    ./scripts/prebuild.sh
    print_success "Native projects rebuilt"
fi

# Step 9: Install iOS dependencies
if [ "$DRY_RUN" = false ]; then
    install_ios_dependencies
fi

# Step 10: Final validation
if [ "$DRY_RUN" = false ]; then
    echo ""
    if ! post_switch_validation; then
        print_error "Final validation failed"
        exit 1
    fi
fi

# Final success message
echo ""
echo "Branch switch completed successfully!"
echo "======================================="
if [ "$DRY_RUN" = false ]; then
    print_success "Current branch: $(git branch --show-current)"
    print_success "Environment is ready for testing"
else
    print_success "Dry run completed - no changes were made"
fi

# Show execution time
end_time=$(date +%s)
execution_time=$((end_time - START_TIME))
print_info "Total execution time: ${execution_time}s"

echo ""
print_info "You can now run:"
print_info "  yarn ios     - to run on iOS"
print_info "  yarn android - to run on Android"
print_info "  yarn start   - to start Metro bundler"
echo ""
print_info "Log file available at: $LOG_FILE"
