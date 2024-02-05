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
