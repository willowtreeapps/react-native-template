# Why We Use Expo Router

This project uses Expo Router as the primary navigation architecture, with a file-based shell that maps naturally to routes and a root stack plus tab-first flow. We chose Expo Router over alternatives such as react-navigation because it aligns better with Expo-native paradigms and enables native-first capabilities such as Link Previews and Zoom Transitions. We made this decision to keep navigation predictable for teams and agents, reduce architectural drift as features are added, and preserve a clear boundary between routing structure and feature implementation.
