# Jay - Jujutsu Git Helper

## Overview

Jay is a Bash script that simplifies Jujutsu (jj) workflows with interactive prompts using `gum`. It supports initializing Jujutsu repositories, committing, squashing, or abandoning changes, and works with both standalone and Git-colocated setups.

## Features

- **Repository Setup**: Initialize Jujutsu repositories (standalone or colocated with Git)
- **Change Management**: Commit, squash, or abandon working changes
- **Revision Control**: Create new revisions and manage revision history
- **Bookmark Operations**: Create, move, and manage bookmarks
- **Remote Integration**: Push, pull, and manage remote repositories
- **Branch Management**: Create new branches with automatic bookmark setup
- **Interactive Interface**: Styled prompts with `gum` for intuitive navigation
- **Smart Detection**: Automatically detects repository state and shows relevant options
- **Error Prevention**: Validates dependencies and provides helpful error messages

## Prerequisites

- Jujutsu (`jj`): [Install](https://github.com/martinvonz/jj)
- `gum`: [Install](https://github.com/charmbracelet/gum)
- Git (for colocated setups)
- Bash

## Installation

1. Save as `jay.sh` and make executable:

   ```bash
   chmod +x jay.sh
   ```

2. Optionally, move to `$PATH`:

   ```bash
   mv jay.sh /usr/local/bin/jay
   ```

## Usage

Run in a project directory:

```bash
./jay.sh
# or
jay
```

### Workflow

Jay automatically detects your repository state and presents relevant options:

#### New Project (No `.git` or `.jj`)
- **Colocated**: Initialize with Git integration for existing Git workflows
- **Standalone**: Pure Jujutsu setup for modern version control

#### Existing Git Project (`.git` only)
- **Link Jujutsu**: Connect Jujutsu to your existing Git repository

#### Standalone Jujutsu (`.jj` only)
- **new**: Create a new revision from any bookmark
- **commit**: Finalize changes with a commit message
- **squash**: Merge current work into parent commit
- **bookmark**: Create, move, or manage bookmarks
- **remote**: Push, pull, or add remote repositories
- **abandon**: Discard current changes safely
- **branch**: Create new branches with bookmarks

#### Colocated Setup (Both `.jj` and `.git`)
- **commit**: Create commits with automatic Git branch synchronization
- **squash**: Squash changes while maintaining Git compatibility
- **abandon**: Safely discard changes in both systems

## Examples

### Creating Your First Commit
```bash
./jay.sh
# → Choose your action: [new] [commit] [squash] [bookmark] [remote] [abandon] [branch]
# → Select "commit"
# → Final commit message: "Add new feature"
# → Choose a branch to commit: [main] [feature-branch]
# → ✅ Created a new commit
```

### Setting Up a New Project
```bash
./jay.sh
# → No .git or .jj found. How do you want to initialize JJ? [colocate] [standalone]
# → Select "colocate" for Git integration or "standalone" for pure Jujutsu
```

### Managing Bookmarks
```bash
./jay.sh
# → Choose your action: [bookmark]
# → [move] [create] [delete]
# → Select bookmark and destination
```

## Troubleshooting

### Command Not Found Errors
Jay validates required dependencies on startup. If you see:
```
Error: Required command 'jj' not found. Please install it first.
```

Install the missing dependency:
- **Jujutsu**: Follow [installation guide](https://github.com/martinvonz/jj)
- **gum**: Follow [installation guide](https://github.com/charmbracelet/gum)

### Permission Issues
If you get permission denied:
```bash
chmod +x jay.sh
```

### Path Issues
Ensure commands are available:
```bash
which jj gum git
```

## Notes

- **Location**: Run from your project root directory
- **Dependencies**: Automatically validates `jj`, `gum`, and `git` availability
- **Safety**: Includes confirmation prompts for destructive operations
- **Compatibility**: Works with existing Git workflows in colocated mode
- **State Detection**: Automatically adapts interface based on repository type

## License

MIT License

