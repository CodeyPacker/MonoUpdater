# Monorepo Dependency Update Script

This script automates the process of updating specific dependencies within `package.json` files of child sites contained in multiple monorepos. It is designed to selectively update sites based on the current version of a set of dependencies, streamlining the maintenance and upgrade process of projects within a monorepo structure.

## Features

- **Selective Dependency Updates**: Targets updates based on the current ("from") version to a new ("to") version.
- **Caret Version Handling**: Accurately processes version strings with carets (`^`), ensuring compatibility with semantic versioning.
- **Automated Git Workflow**: Integrates with Git to automate branching, stashing, committing, and pushing changes.
- **Enhanced Console Output**: Provides colorful and emoji-enhanced output for better readability and user experience.
- **Update Summary**: Outputs a summary of all updated sites at the end of the script's execution, indicating the old and new versions.

## Prerequisites

- **`jq`**: A lightweight and flexible command-line JSON processor, required for parsing and updating `package.json` files.
- **Git**: Must be installed and configured for your user account.
- **Bash Shell Environment**: The script is written for Bash, which is available by default on macOS.

## Installation

### Installing `jq` on macOS

If you do not have `jq` installed, you can easily install it using Homebrew:

```bash
brew install jq

## Make the Script Executable
Open a terminal and navigate to the directory where you've saved updateSites.sh. Then, run the following command to make it executable:

```bash
chmod +x updateSites.sh

This command changes the script's permissions to allow it to be run as a program.

## Run the Script with Parameters
With the script now executable, you can run it directly from the terminal by specifying the --from and --to version parameters as arguments. Here's the syntax based on your request:
```bash
./updateSites.sh --from 12.4.1 --to 12.7.0

Or, if you've placed the script in a directory that's included in your PATH, you can run it without the ./ prefix from any location:

```bash
updateSites.sh --from 12.4.1 --to 12.7.0
This command tells the script to look for sites within each monorepo that are currently on version 12.4.1 and update them to version 12.7.0.
