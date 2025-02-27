# App Launcher

A simple yet elegant terminal-based application launcher that lets you organize and run your scripts through an interactive menu interface.

## Overview

The App Launcher is a bash script that:

1. Scans a predefined directory structure for application scripts
2. Presents them in a nicely formatted terminal menu
3. Runs the selected application with proper input/output handling
4. Returns to the menu after execution

## Features

- 📂 Organized application structure
- 🖥️ Clean terminal UI with box-drawing characters
- 🔄 Automatic app discovery
- 🔒 Execution isolation for each app
- 🔤 Formatted output capture and display

## Directory Structure

```
app-launcher/
├── main.sh                # Main launcher script
├── apps/                  # Directory for all applications
│   ├── app1/              # First application
│   │   └── app1.sh        # Application script
│   ├── app2/              # Second application
│   │   └── app2.sh        # Application script
│   └── ...
└── README.md              # This documentation
```

## Installation

1. Clone or download this repository:

```bash
git clone https://github.com/your-username/app-launcher.git
cd app-launcher
```

2. Make the main script executable:

```bash
chmod +x main.sh
```

3. Run the launcher:

```bash
./main.sh
```

## UI Example

When you run the main script, you'll see a menu like this:

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          Available Applications                              │
├──────────────────────────────────────────────────────────────────────────────┤
│  1) app1                                                                     │
│  2) app2                                                                     │
│  3) helix-config                                                             │
└──────────────────────────────────────────────────────────────────────────────┘
Enter the number of the app to run (or 'q' to quit):
```

After selecting an application, you'll see the output formatted like this:

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                             Running app1                                     │
├──────────────────────────────────────────────────────────────────────────────┤
│ App 1 is starting...                                                         │
│ Performing task...                                                           │
│ Task completed successfully!                                                 │
├──────────────────────────────────────────────────────────────────────────────┤
│                        app1 execution completed                              │
└──────────────────────────────────────────────────────────────────────────────┘
Press Enter to continue...
```

## Adding New Applications

To add a new application to the launcher:

1. Create a new directory in the `apps` folder with your application name:

```bash
mkdir -p apps/myapp
```

2. Create a script with the same name as the directory:

```bash
touch apps/myapp/myapp.sh
```

3. Make the script executable:

```bash
chmod +x apps/myapp/myapp.sh
```

4. Edit the script to include your application code. Your script should output text to be displayed in the launcher UI.

### Example App Script

Here's a simple example of a new app script:

```bash
#!/bin/bash

echo "Hello from my new application!"
echo "Current date and time: $(date)"
echo "This application was created by $(whoami)"
```

### Requirements for App Scripts

- The script must be executable
- The script must have the same name as its parent directory
- The script should output text to standard output
- The script shouldn't require additional input after starting (or handle its own input)

## Included Applications

### Helix Configuration

The repository includes a sample "helix-config" application that sets up configuration for the Helix text editor.

## Advanced Usage

### Customizing the UI

You can modify the `TERMINAL_WIDTH` variable in `main.sh` to change the width of the displayed UI boxes:

```bash
# Set a fixed width for the terminal output
TERMINAL_WIDTH=80
```

### Adding Dependencies

If your application requires additional files, include them in your application directory:

```
apps/
└── myapp/
    ├── myapp.sh
    ├── config.json
    └── helper.sh
```

## Troubleshooting

- **App doesn't appear in menu**: Ensure the directory and script names match and the script is executable.
- **Script execution fails**: Check the script permissions and ensure it runs correctly when executed directly.

## License

[Insert your license information here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.