from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, PageBreak
)

OUTPUT = "RN_Template_Claude_Onboarding.pdf"
W, H = A4
MARGIN = 20 * mm
CONTENT_W = W - 2 * MARGIN   # ~155mm / 439pt

# ── Palette ───────────────────────────────────────────────────────────────────
DARK   = colors.HexColor("#0F1117")
ACCENT = colors.HexColor("#6C63FF")
MUTED  = colors.HexColor("#6B7280")
GREEN  = colors.HexColor("#22C55E")
ORANGE = colors.HexColor("#F97316")
BLUE   = colors.HexColor("#3B82F6")
BGROW  = colors.HexColor("#F8F9FF")
BGCODE = colors.HexColor("#F1F5F9")
BGINFO = colors.HexColor("#EEF2FF")
GRIDCL = colors.HexColor("#E5E7EB")
WHITE  = colors.white

# ── Styles ────────────────────────────────────────────────────────────────────
base = getSampleStyleSheet()

def S(name, parent="Normal", **kw):
    return ParagraphStyle(name, parent=base[parent], **kw)

sTitle    = S("sTitle",  "Title",   fontSize=28, textColor=WHITE,  leading=34, spaceAfter=4,  alignment=TA_CENTER)
sSubt     = S("sSubt",  "Normal",  fontSize=12, textColor=colors.HexColor("#C4C4FF"), leading=18, alignment=TA_CENTER)
sH1       = S("sH1",    "Heading1",fontSize=17, textColor=ACCENT,  leading=22, spaceBefore=16, spaceAfter=5)
sH2       = S("sH2",    "Heading2",fontSize=11, textColor=DARK,    leading=16, spaceBefore=10, spaceAfter=3)
sBody     = S("sBody",  "Normal",  fontSize=9,  textColor=DARK,    leading=14, spaceAfter=3)
sMuted    = S("sMuted", "Normal",  fontSize=8,  textColor=MUTED,   leading=12, spaceAfter=2,  alignment=TA_CENTER)
sCode     = S("sCode",  "Normal",  fontSize=7.5,textColor=colors.HexColor("#1E293B"),
              fontName="Courier",  leading=12,  leftIndent=0,      spaceAfter=0)
sBullet   = S("sBlt",   "Normal",  fontSize=9,  textColor=DARK,    leading=14,
              leftIndent=12, bulletIndent=4,    spaceAfter=2)
sCaption  = S("sCap",   "Normal",  fontSize=7.5,textColor=MUTED,   leading=11, alignment=TA_CENTER, spaceAfter=4)
sTH       = S("sTH",    "Normal",  fontSize=8,  textColor=WHITE,   fontName="Helvetica-Bold", leading=12)
sTD       = S("sTD",    "Normal",  fontSize=8,  textColor=DARK,    leading=12)
sTDcode   = S("sTDc",   "Normal",  fontSize=8,  textColor=ACCENT,  fontName="Courier-Bold", leading=12)
sTDcourier= S("sTDcr",  "Normal",  fontSize=7.5,textColor=colors.HexColor("#1E293B"),
              fontName="Courier",  leading=12)

# ── Helpers ───────────────────────────────────────────────────────────────────
def hr(c=ACCENT, t=0.5):
    return HRFlowable(width="100%", thickness=t, color=c, spaceAfter=6, spaceBefore=4)

def space(h=6):
    return Spacer(1, h)

def code_block(lines, width=None):
    w = width or CONTENT_W
    rows = [[Paragraph(ln, sCode)] for ln in lines]
    t = Table(rows, colWidths=[w - 24])
    t.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), BGCODE),
        ("TOPPADDING",    (0,0), (-1,-1), 7),
        ("BOTTOMPADDING", (0,0), (-1,-1), 7),
        ("LEFTPADDING",   (0,0), (-1,-1), 12),
        ("RIGHTPADDING",  (0,0), (-1,-1), 12),
    ]))
    return t

def info_box(text, bg=BGINFO, border=ACCENT):
    t = Table([[Paragraph(text, sBody)]], colWidths=[CONTENT_W])
    t.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), bg),
        ("LEFTPADDING",   (0,0), (-1,-1), 12),
        ("RIGHTPADDING",  (0,0), (-1,-1), 12),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("BOX",           (0,0), (-1,-1), 1.5, border),
    ]))
    return t

def simple_table(data, col_widths, header_bg=DARK):
    t = Table(data, colWidths=col_widths)
    style = [
        ("BACKGROUND",    (0,0), (-1,0),  header_bg),
        ("TEXTCOLOR",     (0,0), (-1,0),  WHITE),
        ("FONTNAME",      (0,0), (-1,0),  "Helvetica-Bold"),
        ("FONTSIZE",      (0,0), (-1,-1), 8),
        ("ROWBACKGROUNDS",(0,1), (-1,-1), [WHITE, BGROW]),
        ("GRID",          (0,0), (-1,-1), 0.3, GRIDCL),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("TOPPADDING",    (0,0), (-1,-1), 6),
        ("BOTTOMPADDING", (0,0), (-1,-1), 6),
        ("LEFTPADDING",   (0,0), (-1,-1), 8),
        ("RIGHTPADDING",  (0,0), (-1,-1), 8),
    ]
    t.setStyle(TableStyle(style))
    return t

def rule_card(title, desc, accent_color):
    """Colored left-border rule card using a 2-col table."""
    bar   = Table([[""]], colWidths=[4], rowHeights=[None])
    bar.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), accent_color),
        ("TOPPADDING",    (0,0), (-1,-1), 0),
        ("BOTTOMPADDING", (0,0), (-1,-1), 0),
        ("LEFTPADDING",   (0,0), (-1,-1), 0),
        ("RIGHTPADDING",  (0,0), (-1,-1), 0),
    ]))
    body_w = CONTENT_W - 4 - 20   # subtract bar + padding
    body = Table(
        [[Paragraph(f"<b>{title}</b>", sH2)],
         [Paragraph(desc, sBody)]],
        colWidths=[body_w]
    )
    body.setStyle(TableStyle([
        ("TOPPADDING",    (0,0), (-1,-1), 4),
        ("BOTTOMPADDING", (0,0), (-1,-1), 4),
        ("LEFTPADDING",   (0,0), (-1,-1), 0),
        ("RIGHTPADDING",  (0,0), (-1,-1), 0),
    ]))
    card = Table([[bar, body]], colWidths=[4, body_w + 16])
    card.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), BGROW),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("TOPPADDING",    (0,0), (-1,-1), 10),
        ("BOTTOMPADDING", (0,0), (-1,-1), 10),
        ("LEFTPADDING",   (0,0), (-1,-1), 0),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("LEFTPADDING",   (0,0), (0,-1), 0),
        ("RIGHTPADDING",  (0,0), (0,-1), 0),
    ]))
    return card

# ── Page templates ────────────────────────────────────────────────────────────
def cover_page(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(DARK)
    canvas.rect(0, 0, W, H, fill=1, stroke=0)
    canvas.setFillColor(ACCENT)
    canvas.rect(0, H - 5*mm, W, 5*mm, fill=1, stroke=0)
    canvas.rect(0, 0, W, 2*mm, fill=1, stroke=0)
    # subtle grid
    canvas.setStrokeColor(colors.HexColor("#1A1A2E"))
    canvas.setLineWidth(0.25)
    for x in range(0, int(W), 18):
        canvas.line(x, 0, x, H)
    for y in range(0, int(H), 18):
        canvas.line(0, y, W, y)
    canvas.restoreState()

def interior_page(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(ACCENT)
    canvas.rect(0, 0, 2.5*mm, H, fill=1, stroke=0)
    canvas.setStrokeColor(GRIDCL)
    canvas.setLineWidth(0.4)
    canvas.line(MARGIN, H - 11*mm, W - MARGIN, H - 11*mm)
    canvas.setFont("Helvetica", 7)
    canvas.setFillColor(MUTED)
    canvas.drawString(MARGIN, 7*mm, "React Native Template + Claude — Onboarding Guide")
    canvas.drawRightString(W - MARGIN, 7*mm, f"Page {doc.page}")
    canvas.restoreState()

# ── Build story ───────────────────────────────────────────────────────────────
doc = SimpleDocTemplate(
    OUTPUT, pagesize=A4,
    leftMargin=MARGIN, rightMargin=MARGIN,
    topMargin=MARGIN, bottomMargin=16*mm,
    title="RN Template + Claude — Onboarding",
    author="React Native Template",
)
story = []

# ═══════════════════════════════════════════════════════
# COVER
# ═══════════════════════════════════════════════════════
story += [
    space(55),
    Paragraph("React Native Template", sTitle),
    Paragraph("+ Claude", ParagraphStyle("acc", parent=sTitle, textColor=ACCENT, fontSize=34)),
    space(6),
    Paragraph("Onboarding &amp; Developer Guide", sSubt),
    space(4),
    Paragraph("Everything your team needs to build with confidence.", sMuted),
    space(28),
]

# tech pills
pill_bg = colors.HexColor("#1C1C2E")
pills = [["Expo SDK 53", "TypeScript", "React Query", "Reanimated", "Maestro E2E", "Storybook"]]
tpills = Table(pills, colWidths=[CONTENT_W / 6] * 6)
tpills.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (-1,-1), pill_bg),
    ("TEXTCOLOR",     (0,0), (-1,-1), colors.HexColor("#C4C4FF")),
    ("FONTNAME",      (0,0), (-1,-1), "Helvetica-Bold"),
    ("FONTSIZE",      (0,0), (-1,-1), 8),
    ("ALIGN",         (0,0), (-1,-1), "CENTER"),
    ("VALIGN",        (0,0), (-1,-1), "MIDDLE"),
    ("TOPPADDING",    (0,0), (-1,-1), 7),
    ("BOTTOMPADDING", (0,0), (-1,-1), 7),
    ("GRID",          (0,0), (-1,-1), 0.5, colors.HexColor("#2A2A3E")),
]))
story += [tpills, PageBreak()]

# ═══════════════════════════════════════════════════════
# 1. WHAT IS THIS TEMPLATE
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("1. What Is This Template?", sH1), hr(),
    Paragraph(
        "An Expo-managed React Native template pre-configured with a curated set of tools, "
        "conventions, and Claude AI integration. It gives your team a shared foundation so "
        "every developer — regardless of experience level — follows the same patterns from day one.",
        sBody),
    space(8),
]

stack_data = [
    [Paragraph("Core Stack", sTH),   Paragraph("Testing &amp; DX", sTH)],
    [Paragraph("Expo SDK 53 — managed workflow, OTA updates", sTD),
     Paragraph("Jest + RNTL — unit &amp; component tests", sTD)],
    [Paragraph("TypeScript — strict mode enforced", sTD),
     Paragraph("Maestro — end-to-end device flows", sTD)],
    [Paragraph("React Query — server state &amp; caching", sTD),
     Paragraph("ESLint + Prettier — consistent formatting", sTD)],
    [Paragraph("Reanimated — 60fps animations", sTD),
     Paragraph("Path aliases — @/ imports throughout", sTD)],
    [Paragraph("Storybook — component documentation", sTD),
     Paragraph("Claude AI — enforced conventions", sTD)],
]
tstack = Table(stack_data, colWidths=[CONTENT_W/2, CONTENT_W/2])
tstack.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (-1,0),  DARK),
    ("ROWBACKGROUNDS",(0,1), (-1,-1), [WHITE, BGROW]),
    ("GRID",          (0,0), (-1,-1), 0.3, GRIDCL),
    ("VALIGN",        (0,0), (-1,-1), "MIDDLE"),
    ("TOPPADDING",    (0,0), (-1,-1), 6),
    ("BOTTOMPADDING", (0,0), (-1,-1), 6),
    ("LEFTPADDING",   (0,0), (-1,-1), 8),
    ("RIGHTPADDING",  (0,0), (-1,-1), 8),
]))
story += [tstack, space(10)]

# ═══════════════════════════════════════════════════════
# 2. PROJECT STRUCTURE
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("2. Project Structure", sH1), hr(),
    Paragraph("The project follows a clear, opinionated folder structure:", sBody),
    space(5),
    code_block([
        "your-app/",
        "  src/",
        "    components/    # Shared UI components (used by 2+ screens)",
        "    constants/     # App-wide constants",
        "    hooks/         # Custom React hooks",
        "    screens/       # Screen-level components + local components",
        "    theme/         # Design tokens: colors, typography, spacing",
        "    utils/         # Pure utility functions",
        "  e2e/             # Maestro end-to-end test flows",
        "  scripts/         # Shell scripts for setup and CI",
        "  .claude/         # Claude AI configuration",
        "    rules/         # Code conventions Claude enforces",
        "    commands/      # Custom slash commands (/deploy, /setup)",
    ]),
    space(6),
    info_box(
        "<b>Key principle:</b> Every folder has a single responsibility. "
        "Claude knows this structure and will always place new files in the correct location."
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 3. WHAT WAS MODIFIED / ADDED
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("3. What Was Added &amp; Modified", sH1), hr(),
    Paragraph(
        "The following changes were made to enable Claude integration and enforce team conventions:",
        sBody),
    space(6),
    simple_table(
        [
            [Paragraph("File / Folder", sTH),
             Paragraph("What Changed", sTH),
             Paragraph("Why", sTH)],
            [Paragraph("tsconfig.json", sTDcourier),
             Paragraph("Added baseUrl + @/* paths", sTD),
             Paragraph("Enables @/ imports across all src/ files", sTD)],
            [Paragraph("CLAUDE.md", sTDcourier),
             Paragraph("Created — team instructions", sTD),
             Paragraph("Claude reads this on every session start", sTD)],
            [Paragraph(".claude/rules/\ncode-style.md", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("No barrels, @/ aliases, no inline styles, named exports", sTD)],
            [Paragraph(".claude/rules/\ntesting.md", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("Jest colocation, naming, jestWrapper, Maestro rules", sTD)],
            [Paragraph(".claude/rules/\nrn-conventions.md", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("Component tiers, hooks, theme, accessibility", sTD)],
            [Paragraph(".claude/commands/\ndeploy.md", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("Defines the /deploy slash command", sTD)],
            [Paragraph(".claude/commands/\nsetup.md", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("Defines the /setup interactive library wizard", sTD)],
            [Paragraph("scripts/\nqa-branch-switch.sh", sTDcourier),
             Paragraph("Created", sTD),
             Paragraph("Full branch switch workflow for QA engineers", sTD)],
        ],
        col_widths=[46*mm, 46*mm, 73*mm],
        header_bg=ACCENT,
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 4. PATH ALIASES
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("4. Path Aliases — @/ Imports", sH1), hr(),
    Paragraph(
        "<b>tsconfig.json</b> now maps <b>@/*</b> to <b>src/*</b>. "
        "You never need to count dots in relative imports. "
        "Expo + Metro resolve these natively — no Babel plugin needed.",
        sBody),
    space(6),
]

COL2 = CONTENT_W / 2 - 3
alias_data = [
    [Paragraph("Good", sTH), Paragraph("Bad", sTH)],
    [Paragraph("import {useTheme} from '@/hooks/useTheme';", sTDcourier),
     Paragraph("import {useTheme} from '../../hooks/useTheme';", sTDcourier)],
    [Paragraph("import {testIds} from '@/utils/testIds';", sTDcourier),
     Paragraph("import {testIds} from '../../../utils/testIds';", sTDcourier)],
    [Paragraph("import {HomeScreen} from '@/screens/HomeScreen';", sTDcourier),
     Paragraph("import {HomeScreen} from '../screens/HomeScreen';", sTDcourier)],
]
talias = Table(alias_data, colWidths=[COL2, COL2])
talias.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (0,0),  GREEN),
    ("BACKGROUND",    (1,0), (1,0),  colors.HexColor("#EF4444")),
    ("ROWBACKGROUNDS",(0,1), (-1,-1), [WHITE, BGROW]),
    ("GRID",          (0,0), (-1,-1), 0.3, GRIDCL),
    ("VALIGN",        (0,0), (-1,-1), "MIDDLE"),
    ("TOPPADDING",    (0,0), (-1,-1), 6),
    ("BOTTOMPADDING", (0,0), (-1,-1), 6),
    ("LEFTPADDING",   (0,0), (-1,-1), 8),
    ("RIGHTPADDING",  (0,0), (-1,-1), 8),
]))
story += [talias, space(10)]

# ═══════════════════════════════════════════════════════
# 5. COMPONENT ARCHITECTURE
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("5. Component Architecture", sH1), hr(),
    Paragraph("Components follow a two-tier model based on how broadly they are used:", sBody),
    space(6),
    simple_table(
        [
            [Paragraph("Tier", sTH), Paragraph("Location", sTH),
             Paragraph("When to use", sTH), Paragraph("Example", sTH)],
            [Paragraph("Shared", sTD),
             Paragraph("src/components/", sTDcourier),
             Paragraph("Used in 2+ screens", sTD),
             Paragraph("Button, Card, Avatar", sTD)],
            [Paragraph("Local", sTD),
             Paragraph("src/screens/<Name>/components/", sTDcourier),
             Paragraph("Used in 1 screen only", sTD),
             Paragraph("HeroBanner, StatsRow", sTD)],
        ],
        col_widths=[20*mm, 60*mm, 48*mm, 37*mm],
    ),
    space(8),
    Paragraph("<b>Shared component structure (with tests/stories):</b>", sH2),
    code_block([
        "src/components/Button/",
        "  Button.tsx            # component",
        "  Button.test.tsx       # unit tests",
        "  Button.stories.tsx    # Storybook stories (optional)",
    ]),
    space(6),
    Paragraph("<b>Local component structure (screen-scoped):</b>", sH2),
    code_block([
        "src/screens/",
        "  HomeScreen.tsx",
        "  HomeScreen.test.tsx",
        "  components/           # only used by HomeScreen",
        "    HeroBanner.tsx",
        "    StatsRow.tsx",
    ]),
    space(6),
    info_box(
        "<b>Prefix convention:</b> When Claude creates a shared component it will ask "
        "if you want a prefix (e.g. App, UI, Base). If you choose one it will be applied "
        "consistently: AppButton, AppCard, AppAvatar. You can skip the prefix and use plain names."
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 6. CODE STYLE RULES
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("6. Code Style Rules", sH1), hr(),
    space(4),
    rule_card("No Barrel Files",
        "Do NOT create index.ts files that re-export everything from a folder. "
        "Import directly from the source file. "
        "Exception: src/theme/index.ts is intentional — it is the public API of a cohesive module.",
        ORANGE),
    space(5),
    rule_card("No Inline Styles",
        "Never write style={{...}} directly on a component. "
        "Always use StyleSheet.create() or theme tokens. "
        "Dynamic values like colors can be mixed in as a second array item: [styles.container, {backgroundColor: theme.bg}].",
        BLUE),
    space(5),
    rule_card("No any Type",
        "strict: true is enforced. Use unknown + type narrowing instead of any. "
        "Use interface for object shapes, type for unions and utility types. "
        "Prefer explicit return types on exported functions.",
        ACCENT),
    space(5),
    rule_card("Named Exports Only",
        "Use named exports everywhere. Default exports are only allowed for the root App component.",
        GREEN),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 7. TESTING CONVENTIONS
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("7. Testing Conventions", sH1), hr(),
    Paragraph("Two independent testing layers — each used for a different purpose:", sBody),
    space(6),
    simple_table(
        [
            [Paragraph("Layer", sTH), Paragraph("Tool", sTH),
             Paragraph("Location", sTH), Paragraph("Tests what?", sTH)],
            [Paragraph("Unit / Component", sTD),
             Paragraph("Jest + RNTL", sTD),
             Paragraph("Next to source file", sTD),
             Paragraph("Logic, rendering, interactions", sTD)],
            [Paragraph("End-to-End", sTD),
             Paragraph("Maestro", sTD),
             Paragraph("e2e/ folder", sTD),
             Paragraph("Full user flows on device", sTD)],
        ],
        col_widths=[38*mm, 32*mm, 40*mm, 54*mm],
    ),
    space(8),
    Paragraph("<b>Unit test naming convention:</b>", sH2),
    code_block([
        "describe('TodoCount', () => {",
        "  it('should render the count returned by the API', () => { ... });",
        "  it('should show a loading state while fetching', () => { ... });",
        "});",
    ]),
    space(6),
    Paragraph("<b>Tests that use React Query must use jestWrapper:</b>", sH2),
    code_block([
        "import {jestWrapper} from '@/utils/jestWrapper';",
        "",
        "render(<TodoCount />, {wrapper: jestWrapper});",
    ]),
    space(6),
    Paragraph("<b>Maestro e2e flow structure:</b>", sH2),
    code_block([
        "appId: com.yourorg.yourapp",
        "---",
        "- launchApp:",
        "    arguments:",
        "      isE2E: true    # disables LogBox",
        "- assertVisible: 'Hello World!'",
        "- tapOn: 'Sign In'",
    ]),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 8. CLAUDE INTEGRATION
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("8. Claude AI Integration", sH1), hr(),
    Paragraph(
        "Claude Code is configured to understand this project's conventions automatically. "
        "Every session, Claude reads CLAUDE.md and all files in .claude/rules/ before writing any code. "
        "You don't need to repeat instructions — Claude already knows the rules.",
        sBody),
    space(6),
    code_block([
        ".claude/",
        "  rules/              # Claude reads these on every session",
        "    code-style.md     # TypeScript, imports, naming, styling",
        "    testing.md        # Jest + Maestro conventions",
        "    rn-conventions.md # Component structure, hooks, theme",
        "  commands/           # Slash commands you trigger manually",
        "    deploy.md         # /deploy — runs prebuild for iOS/Android",
        "    setup.md          # /setup — interactive library wizard",
    ]),
    space(8),
    Paragraph("<b>Available Slash Commands:</b>", sH2),
    space(4),
    simple_table(
        [
            [Paragraph("Command", sTH), Paragraph("What it does", sTH)],
            [Paragraph("/deploy", sTDcode),
             Paragraph(
                "Asks for target platform (iOS / Android / both), runs scripts/prebuild.sh, "
                "verifies native output, and tells you what to run next.", sTD)],
            [Paragraph("/setup", sTDcode),
             Paragraph(
                "Interactive wizard: reads your package.json, asks 6 questions about your "
                "project, suggests libraries by category with justification. "
                "Nothing is installed until you confirm.", sTD)],
        ],
        col_widths=[28*mm, CONTENT_W - 28*mm],
        header_bg=ACCENT,
    ),
    space(6),
    info_box(
        "<b>Important:</b> Claude will never install libraries or make breaking changes without "
        "your confirmation. The /setup wizard has an explicit confirmation step before running any installs."
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 9. HOW TO USE CLAUDE DAY-TO-DAY
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("9. How to Use Claude Day-to-Day", sH1), hr(),
    Paragraph(
        "Claude Code runs as an AI assistant directly in your terminal. "
        "It reads the project conventions automatically on every session — "
        "you do not need to explain the rules each time.",
        sBody),
    space(8),

    Paragraph("<b>Starting a session:</b>", sH2),
    code_block([
        "# Open Claude Code in the project root",
        "cd your-project",
        "claude",
        "",
        "# Claude will automatically read:",
        "#   CLAUDE.md          — team instructions",
        "#   .claude/rules/     — code conventions",
        "#   .claude/commands/  — available slash commands",
    ]),
    space(8),

    Paragraph("<b>Triggering slash commands:</b>", sH2),
    Paragraph(
        "Type a slash command directly in the Claude chat. "
        "Claude will execute the workflow defined in .claude/commands/.",
        sBody),
    space(4),
    code_block([
        "/deploy",
        "# Claude asks: which platform? (ios / android / both)",
        "# Then runs: ./scripts/prebuild.sh --platform ios",
        "# Then confirms native output and prints next steps",
        "",
        "/setup",
        "# Claude reads package.json, asks 6 questions about your app,",
        "# suggests libraries by category. Nothing installs until you confirm.",
    ]),
    space(8),

    Paragraph("<b>Practical prompt examples for this template:</b>", sH2),
    space(4),
    simple_table(
        [
            [Paragraph("What you want", sTH), Paragraph("What to type to Claude", sTH)],
            [Paragraph("Create a shared component", sTD),
             Paragraph('"Create a Card component that receives title and subtitle as props"', sTDcourier)],
            [Paragraph("Create a screen-local component", sTD),
             Paragraph('"Add a HeroBanner component to the HomeScreen, local only"', sTDcourier)],
            [Paragraph("Create a custom hook", sTD),
             Paragraph('"Create a useUserProfile hook that fetches from /api/profile"', sTDcourier)],
            [Paragraph("Add a new screen", sTD),
             Paragraph('"Create a ProfileScreen with a loading state and error state"', sTDcourier)],
            [Paragraph("Write unit tests", sTD),
             Paragraph('"Write tests for the TodoCount component"', sTDcourier)],
            [Paragraph("Add a Maestro e2e flow", sTD),
             Paragraph('"Create a Maestro flow for the login screen"', sTDcourier)],
            [Paragraph("Review code for violations", sTD),
             Paragraph('"Review HomeScreen.tsx for any convention violations"', sTDcourier)],
            [Paragraph("Add a library", sTD),
             Paragraph('"Add Zustand for global UI state"', sTDcourier)],
        ],
        col_widths=[48*mm, CONTENT_W - 48*mm],
        header_bg=ACCENT,
    ),
    space(8),

    Paragraph("<b>What Claude does automatically (without being asked):</b>", sH2),
    space(4),
    simple_table(
        [
            [Paragraph("Behavior", sTH), Paragraph("Example", sTH)],
            [Paragraph("Places files in the right folder", sTD),
             Paragraph("A shared Button goes to src/components/Button/Button.tsx", sTD)],
            [Paragraph("Uses @/ path aliases", sTD),
             Paragraph("import {useTheme} from '@/hooks/useTheme' — never relative", sTD)],
            [Paragraph("Avoids barrel files", sTD),
             Paragraph("Will not create index.ts re-exports", sTD)],
            [Paragraph("Uses StyleSheet.create()", sTD),
             Paragraph("Will not write style={{...}} inline", sTD)],
            [Paragraph("Wraps React Query calls", sTD),
             Paragraph("Creates a named hook instead of calling useQuery in a component", sTD)],
            [Paragraph("Asks about component prefix", sTD),
             Paragraph('Prompts: "Do you want a prefix? e.g. App, UI, Base"', sTD)],
            [Paragraph("Collocates test files", sTD),
             Paragraph("Creates Component.test.tsx next to Component.tsx", sTD)],
            [Paragraph("Uses theme tokens", sTD),
             Paragraph("Calls useTheme() — never hardcodes '#ffffff'", sTD)],
        ],
        col_widths=[55*mm, CONTENT_W - 55*mm],
    ),
    space(8),

    info_box(
        "<b>Tip:</b> You can ask Claude to explain any decision it makes. "
        'For example: "Why did you put this file in src/components instead of the screen folder?" '
        "Claude will reference the specific rule from .claude/rules/ that guided the choice."
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 10. SCRIPTS REFERENCE
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("10. Scripts Reference", sH1), hr(),

    space(4),
    simple_table(
        [
            [Paragraph("Script", sTH), Paragraph("Purpose", sTH), Paragraph("Audience", sTH)],
            [Paragraph("./scripts/init.sh", sTDcourier),
             Paragraph("Full clean setup from scratch. Deletes node_modules, ios, android and reinstalls everything.", sTD),
             Paragraph("Devs — first setup", sTD)],
            [Paragraph("./scripts/install-\ndependencies.sh", sTDcourier),
             Paragraph("Detects yarn/npm from lock file and installs dependencies.", sTD),
             Paragraph("Called by other scripts", sTD)],
            [Paragraph("./scripts/prebuild.sh", sTDcourier),
             Paragraph("Runs expo prebuild for iOS / Android. Accepts --platform ios|android.", sTD),
             Paragraph("Devs + CI", sTD)],
            [Paragraph("./scripts/qa-branch-\nswitch.sh", sTDcourier),
             Paragraph(
                "Full branch switch for QA: validates env, backs up state, switches branch, "
                "cleans all caches, reinstalls deps, rebuilds native projects, verifies.", sTD),
             Paragraph("QA Engineers", sTD)],
        ],
        col_widths=[44*mm, 88*mm, 33*mm],
    ),
    space(8),
    Paragraph("<b>qa-branch-switch.sh usage:</b>", sH2),
    code_block([
        "./scripts/qa-branch-switch.sh feature/login",
        "./scripts/qa-branch-switch.sh --debug hotfix/payment",
        "./scripts/qa-branch-switch.sh --dry-run develop",
        "./scripts/qa-branch-switch.sh --clean-ports",
        "./scripts/qa-branch-switch.sh --check-auth",
    ]),
    space(6),
    simple_table(
        [
            [Paragraph("Step", sTH), Paragraph("Action", sTH)],
            *[
                [Paragraph(str(n), sTD), Paragraph(action, sTD)]
                for n, action in [
                    (1, "Validate environment (node, yarn/npm, git, Expo CLI)"),
                    (2, "Check GitHub package registry authentication if needed"),
                    (3, "Backup current branch + uncommitted changes"),
                    (4, "Fetch latest from origin + switch to target branch"),
                    (5, "Deep clean: Metro, Watchman, Gradle, Expo caches, node_modules"),
                    (6, "Reinstall dependencies via install-dependencies.sh"),
                    (7, "Rebuild native projects via prebuild.sh"),
                    (8, "Install CocoaPods (iOS) with automatic retry"),
                    (9, "Post-switch validation: package.json, deps, native projects"),
                    (10, "Print run instructions: yarn ios / yarn android / yarn start"),
                ]
            ]
        ],
        col_widths=[14*mm, CONTENT_W - 14*mm],
        header_bg=ACCENT,
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 10. DAILY COMMANDS CHEATSHEET
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("11. Daily Commands Cheatsheet", sH1), hr(),
    space(4),
    simple_table(
        [
            [Paragraph("Command", sTH), Paragraph("Purpose", sTH)],
            [Paragraph("yarn start",           sTDcode), Paragraph("Start Metro bundler", sTD)],
            [Paragraph("yarn ios",             sTDcode), Paragraph("Run on iOS device", sTD)],
            [Paragraph("yarn android",         sTDcode), Paragraph("Run on Android device", sTD)],
            [Paragraph("yarn test",            sTDcode), Paragraph("Run Jest unit tests", sTD)],
            [Paragraph("yarn test:e2e",        sTDcode), Paragraph("Run Maestro e2e tests", sTD)],
            [Paragraph("yarn lint",            sTDcode), Paragraph("ESLint check", sTD)],
            [Paragraph("yarn format",          sTDcode), Paragraph("Prettier format", sTD)],
            [Paragraph("yarn start:storybook", sTDcode), Paragraph("Launch Storybook", sTD)],
            [Paragraph("/deploy",              sTDcode), Paragraph("Claude: run prebuild for a platform", sTD)],
            [Paragraph("/setup",               sTDcode), Paragraph("Claude: interactive library suggestion wizard", sTD)],
        ],
        col_widths=[55*mm, CONTENT_W - 55*mm],
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 11. QA ONBOARDING
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("12. QA Engineer Onboarding", sH1), hr(),
    Paragraph(
        "QA engineers should never manually switch branches. "
        "Always use the branch switch script to avoid stale cache issues and broken native builds.",
        sBody),
    space(6),
    Paragraph("<b>First time setup:</b>", sH2),
    code_block([
        "# 1. Clone the repository",
        "git clone <repo-url> && cd <project-folder>",
        "",
        "# 2. Run full setup",
        "./scripts/init.sh",
        "",
        "# 3. Start the app",
        "yarn ios    # or: yarn android",
    ]),
    space(6),
    Paragraph("<b>Switching branches (daily workflow):</b>", sH2),
    code_block([
        "# Switch to a feature branch",
        "./scripts/qa-branch-switch.sh feature/new-login",
        "",
        "# With debug output",
        "./scripts/qa-branch-switch.sh --debug hotfix/payment",
        "",
        "# Dry run — see what would happen",
        "./scripts/qa-branch-switch.sh --dry-run develop",
        "",
        "# If Metro ports are stuck",
        "./scripts/qa-branch-switch.sh --clean-ports",
    ]),
    space(6),
    info_box(
        "<b>If something fails:</b> Check the log file at the project root: "
        "<b>qa-branch-switch.log</b>. The script will also attempt to restore "
        "your original branch automatically on error."
    ),
    space(10),
]

# ═══════════════════════════════════════════════════════
# 12. QUICK REFERENCE
# ═══════════════════════════════════════════════════════
story += [
    Paragraph("13. Quick Reference Card", sH1), hr(),
    space(4),
    simple_table(
        [
            [Paragraph("Topic", sTH), Paragraph("Rule", sTH)],
            [Paragraph("Component — shared", sTD),
             Paragraph("Used in 2+ screens → src/components/ (Claude asks about prefix)", sTD)],
            [Paragraph("Component — local", sTD),
             Paragraph("Used in 1 screen → src/screens/<Name>/components/", sTD)],
            [Paragraph("Imports", sTD),
             Paragraph("Always @/ — never relative paths going up more than one level", sTD)],
            [Paragraph("Barrel files", sTD),
             Paragraph("Never create index.ts re-exports (except src/theme/index.ts)", sTD)],
            [Paragraph("Styles", sTD),
             Paragraph("Always StyleSheet.create() — never style={{...}} inline", sTD)],
            [Paragraph("Colors", sTD),
             Paragraph("Always theme tokens via useTheme() — never hardcoded hex values", sTD)],
            [Paragraph("TypeScript", sTD),
             Paragraph("No any — use unknown + narrowing. Named exports only", sTD)],
            [Paragraph("Hooks", sTD),
             Paragraph("Always use prefix, one per file, live in src/hooks/", sTD)],
            [Paragraph("Data fetching", sTD),
             Paragraph("Never call useQuery directly in components — wrap in a named hook", sTD)],
            [Paragraph("Animations", sTD),
             Paragraph("Always Reanimated — never the built-in Animated API", sTD)],
            [Paragraph("Tests — unit", sTD),
             Paragraph("Colocated next to source file, named Component.test.tsx", sTD)],
            [Paragraph("Tests — e2e", sTD),
             Paragraph("Maestro flows in e2e/, assert on visible text not testIDs", sTD)],
        ],
        col_widths=[40*mm, CONTENT_W - 40*mm],
    ),
    space(12),
    hr(c=GRIDCL, t=0.3),
    space(4),
    Paragraph(
        "Generated for the React Native Template team. "
        "Keep this document updated when conventions change.",
        sCaption),
]

# ── Build ─────────────────────────────────────────────────────────────────────
doc.build(story, onFirstPage=cover_page, onLaterPages=interior_page)
print(f"PDF created: {OUTPUT}")
