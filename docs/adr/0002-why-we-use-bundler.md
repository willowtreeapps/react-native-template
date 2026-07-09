# Why We Use Bundler

This project standardizes native Ruby tooling on Ruby 3.2 and uses a project-local `Gemfile` with Bundler to install and run gems such as CocoaPods. We made this decision because Ruby 3.2 aligns with the EAS Build environment for Expo SDK 56, while Bundler keeps native gem versions reproducible and isolated per project instead of depending on global machine state. This reduces cross-project conflicts and makes it practical for different apps to require different CocoaPods or related gem versions safely.
