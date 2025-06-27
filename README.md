# Jay - Jujutsu Git Helper

## Overview

Jay is a Bash script that simplifies Jujutsu (jj) workflows with interactive prompts using `gum`. It supports initializing Jujutsu repositories, committing, squashing, or abandoning changes, and works with both standalone and Git-colocated setups.

## Features

- Initialize Jujutsu repositories (standalone or colocated with Git).
- Interactive actions: commit, squash, or abandon changes.
- Git branch and bookmark integration.
- Styled prompts with `gum` for better usability.
- Displays Jujutsu status before actions.

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

- **No `.git` or `.jj`**: Initialize as standalone or colocated with Git.
- **`.git` only**: Link Jujutsu to existing Git repo.
- **`.jj` only**: Choose commit, squash, or abandon.
- **Both `.jj` and `.git`**: Choose commit, squash, or abandon with Git integration.

## Example

```bash
./jay.sh
# Select "commit", enter message
```

## Notes

- Run from project root.
- Ensure `jj`, `gum`, and `git` are in `$PATH`.

## License

MIT License

