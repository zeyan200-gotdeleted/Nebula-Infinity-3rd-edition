# Nebula Infinity Admin Panel - Third Edition Documentation

## Overview
Nebula Infinity (Third Edition) is a modern, user-friendly admin panel designed for Roblox experiences, offering a variety of tools for server management, moderation, and trolling. This advanced administrative framework provides a clean UI interface, responsive controls, giving developers power to manage their communities effectively while maintaining a secure and engaging environment. The Third Edition introduces enhanced features, improved UI/UX, and expanded functionality for both developers and moderators.

> **Note**: This documentation assumes familiarity with Roblox Studio and basic scripting knowledge. For setup assistance, refer to the [Setup Guide](#setup-guide) section.

---

## Key Features
The Third Edition of Nebula Infinity offers a comprehensive suite of tools tailored for Roblox server management:

- **Real-Time Dashboard**: Monitor server status, active players, and admin activity in real time.
- **User Management**: View and manage player information, including Username, UserID, Account Creation Date, and online status. Perform actions like banning, kicking, or muting players.
- **Custom Commands**: Create and execute custom admin commands with an intuitive interface, marked by a pen icon in the UI.
- **Moderation Tools**: Advanced tools for trolling exploiters, issuing warnings, and maintaining server integrity.
- **Responsive UI/UX**: A modern, streamlined interface with smooth animations, optimized for both desktop and mobile devices.
- **Security Enhancements**: Built-in anti-exploit measures to detect and counter unauthorized activities.
- **Customizable Settings**: Tailor the admin panel to your experience’s needs through an accessible settings menu.

---

## Setup Guide
To integrate Nebula Infinity (Third Edition) into your Roblox experience, follow these steps:

1. **Obtain the RBXM File**:
   - Download the Nebula Infinity RBXM file from the Latest release section on this post

2. **Insert the File**:
   - Open Roblox Studio and navigate to **File Explorer** > **ServerScriptService**.
   - Insert the downloaded RBXM file into **ServerScriptService**.

3. **Configure Game Settings**:
   - Go to the **Home Tab** > **Game Settings** > **Security**.
   - Enable the following:
     - **Allow HTTP Requests**: ✅
     - **Enable Studio Access to API Services**: ✅
   - These settings are required for Nebula Infinity’s features to function correctly.

4. **Test the Integration**:
   - Run the game in Roblox Studio using the **Play** option.
   - Ensure the admin panel loads correctly and test basic commands (e.g., `!commands` or `!Dashboard`).

5. **Optional Customization**:
   - Modify the panel’s settings via the **Settings** page to align with your requirements.
   - Add custom commands through the **Command Handler** stylesheet.

---



