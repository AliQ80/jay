# Jays

**Jays** is an interactive CLI helper for [Jujutsu (jj)](https://github.com/martinvonz/jj) that simplifies your workflow using [Gum](https://github.com/charmbracelet/gum). It handles repository initialization, committing, squashing, bookmarking, and GitHub integration with a beautiful, guided interface.

## Prerequisites

*   [Jujutsu (jj)](https://github.com/martinvonz/jj)
*   [Gum](https://github.com/charmbracelet/gum)
*   [GitHub CLI (gh)](https://cli.github.com/) (logged in via `gh auth login`)

## Installation

Save the script as `jays` and make it executable:

```bash
chmod +x jays.sh
```

Optionally move it to your path:

```bash
sudo mv jays.sh /usr/local/bin/jays
```

Or you can just use binmy script manager to install it:

```bash
binmy jays.sh
```

## Usage

Simply run the script in your project directory. Jays automatically detects the repository state and presents the relevant options.

```bash
./jays.sh
```

### Features

*   **Smart Init**: Detects if a repo exists; offers to initialize `jj` standalone or colocated with `git`.
*   **Workflow Actions**: Interactive prompts for `new`, `commit`, `squash`, `abandon`, `bookmark`, and `branch`.
*   **GitHub Integration**: Create, push, and manage remotes directly from the CLI.
*   **Safety**: Confirmation prompts for destructive actions.

## License

GPLv3
