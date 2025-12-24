# Jays - Jujutsu Git Helper

## Overview

Jays is a Bash script that simplifies Jujutsu (jj) workflows with interactive prompts using `gum`. It supports initializing Jujutsu repositories, committing, squashing, or abandoning changes, and works with both standalone and Git-colocated setups. The script includes GitHub integration for creating repositories and automatic push prompts after commits.

## Features

- **Repository Setup**: Initialize Jujutsu repositories (standalone or colocated with Git)
- **Change Management**: Commit, squash, or abandon working changes
- **Revision Control**: Create new revisions and manage revision history
- **Bookmark Operations**: Create, move, and manage bookmarks
- **Remote Integration**: Push, pull, add, remove, and create GitHub repositories
- **GitHub Integration**: Create new GitHub repositories and push projects directly
- **Auto-Push**: Prompts to push changes after successful commits
- **Branch Management**: Create new branches with automatic bookmark setup
- **Interactive Interface**: Styled prompts with `gum` for intuitive navigation
- **Smart Detection**: Automatically detects repository state and shows relevant options
- **Error Prevention**: Validates dependencies and provides helpful error messages

## Prerequisites

- Jujutsu (`jj`): [Install](https://github.com/martinvonz/jj)
- `gum`: [Install](https://github.com/charmbracelet/gum)
- GitHub CLI (`gh`): [Install](https://cli.github.com/) and authenticate with `gh auth login`
- Git (for colocated setups)
- Bash

## Installation

1. Save as `jays.sh` and make executable:

   ```bash
   chmod +x jays.sh
   ```

2. Optionally, move to `$PATH`:

   ```bash
   mv jays.sh /usr/local/bin/jays
   ```

## Usage

Run in a project directory:

```bash
./jays.sh
# or
jays
```

### Workflow

Jays automatically detects your repository state and presents relevant options:

#### New Project (No `.git` or `.jj`)
- **Colocated**: Initialize with Git integration for existing Git workflows
- **Standalone**: Pure Jujutsu setup for modern version control

#### Existing Git Project (`.git` only)
- **Link Jujutsu**: Connect Jujutsu to your existing Git repository

#### Standalone Jujutsu (`.jj` only)
- **new**: Create a new revision from any bookmark
- **commit**: Finalize changes with a commit message (with optional auto-push)
- **squash**: Merge current work into parent commit
- **bookmark**: Create, move, or manage bookmarks
- **remote**: Push, pull, add, remove, or create GitHub repositories
- **abandon**: Discard current changes safely
- **branch**: Create new branches with bookmarks

#### Colocated Setup (Both `.jj` and `.git`)
- **commit**: Create commits with automatic Git branch synchronization (with optional auto-push)
- **squash**: Squash changes while maintaining Git compatibility
- **abandon**: Safely discard changes in both systems

## Examples

### Creating Your First Commit
```bash
./jays.sh
# → Choose your action: [new] [commit] [squash] [bookmark] [remote] [abandon] [branch]
# → Select "commit"
# → Final commit message: "Add new feature"
# → Choose a branch to commit: [main] [feature-branch]
# → ✅ Created a new commit
# → Push 'main' to remote? [y/N]
```

### Setting Up a New Project
```bash
./jays.sh
# → No .git or .jj found. How do you want to initialize JJ? [colocate] [standalone]
# → Select "colocate" for Git integration or "standalone" for pure Jujutsu
```

### Creating a GitHub Repository
```bash
./jays.sh
# → Choose your action: [remote]
# → Choose a remote action: [push] [pull] [add] [remove] [create]
# → Select "create"
# → Enter repository name: my-project
# → Repository visibility: [public] [private]
# → Choose a bookmark to push to new repo: [main]
# → Push 'main' to the new GitHub repository? [y/N]
```

### Managing Bookmarks
```bash
./jays.sh
# → Choose your action: [bookmark]
# → [move] [create] [delete]
# → Select bookmark and destination
```

## Troubleshooting

### Command Not Found Errors
Jays validates required dependencies on startup. If you see:
```
Error: Required command 'jj' not found. Please install it first.
```

Install the missing dependency:
- **Jujutsu**: Follow [installation guide](https://github.com/martinvonz/jj)
- **gum**: Follow [installation guide](https://github.com/charmbracelet/gum)
- **GitHub CLI**: Follow [installation guide](https://cli.github.com/)

### GitHub Authentication
If you see authentication errors:
```
Error: GitHub CLI is not authenticated. Run 'gh auth login' first.
```

Authenticate with GitHub:
```bash
gh auth login
```

### Permission Issues
If you get permission denied:
```bash
chmod +x jays.sh
```

### Path Issues
Ensure commands are available:
```bash
which jj gum git gh
```

## Notes

- **Location**: Run from your project root directory
- **Dependencies**: Automatically validates `jj`, `gum`, `git`, and `gh` availability
- **Safety**: Includes confirmation prompts for destructive operations and pushes
- **Compatibility**: Works with existing Git workflows in colocated mode
- **State Detection**: Automatically adapts interface based on repository type
- **GitHub Integration**: Seamlessly creates repositories and manages remotes
- **Auto-Push**: Optional push prompts after successful commits when remotes exist

## License

GPLv3 License

