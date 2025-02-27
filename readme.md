# Automatic Macos setup 

A simple bash-based framework to manage and run small terminal applications through a unified menu interface.

## What it does

- Provides a central menu to run multiple terminal applications
- Lets you create new applications easily
- Displays application output in a formatted terminal UI

## Setup & Usage

### Setup

1. Clone or download this repository
2. Make the main script executable:
   ```
   chmod +x main.sh
   ```

### Running the framework

```
./main.sh
```

### Using the menu

- Select a number to run an existing application
- Press `W` to create a new application
- Press `Q` to quit

### Creating new apps

When creating a new app:
1. Enter a name using letters, numbers, and hyphens
2. A template script will be generated at `apps/[app-name]/[app-name].sh`
3. Edit this script to add your functionality

### Customizing apps

- Edit any app at `apps/[app-name]/[app-name].sh`
- Add a custom title with `# TITLE: Your App Title` at the top of the script