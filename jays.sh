#!/bin/bash

# Check required dependencies
for cmd in jj gum git gh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Error: Required command '$cmd' not found. Please install it first."
    exit 1
  fi
done

# Check if gh is authenticated
if ! gh auth status >/dev/null 2>&1; then
  echo "❌ Error: GitHub CLI is not authenticated. Run 'gh auth login' first."
  exit 1
fi

gum style \
  --foreground 212 --border-foreground 62 --border rounded \
  --align center --width 30 --margin "1 2" --padding "0 2" \
  'Jay' 'Jujutsu Git helper'

# Check existence of folders
has_git=false
has_jj=false

[ -d .git ] && has_git=true
[ -d .jj ] && has_jj=true

# Case 1: No .git and no .jj
if ! $has_git && ! $has_jj; then
  init=$(gum choose \
      "standalone - Pure Jujutsu setup for modern version control" \
      "colocate - Initialize with Git integration for existing workflows" \
      --header "No .git or .jj found. How do you want to initialize JJ?" | cut -d' ' -f1)

  case "$init" in
  colocate)
    git init
    BRANCH=$(git branch --show-current)
    echo
    jj git init --colocate
    echo
    jj bookmark create "$BRANCH" -r @
    echo
    jj commit -m "initial commit"
    echo
    git switch "$BRANCH"
    ;;
  standalone)
    jj git init
    echo
    echo "Create the first bookmark"
    BOOKMARK=$(gum input --placeholder "name your bookmark")
    jj bookmark create "$BOOKMARK" -r @
    echo
    jj commit -m "initial commit"
    ;;
  *)
    echo "Skipped jj init. Exiting."
    ;;
  esac

  exit 0

# Case 2: .git exists but .jj does not
elif $has_git && ! $has_jj; then
  echo "Found Git repo but no JJ repo."
  if gum confirm "Do you want to initialize JJ and link it to the existing Git repo?"; then
    jj git init --git-repo .
    echo "JJ initialized and linked to Git repo."
  else
    echo "❌ JJ initialization canceled."
  fi
  exit 0

# Case 3: only .jj exist standalone
elif $has_jj && ! $has_git; then

  while true; do
    jj st
    echo

    action=$(gum choose \
        "commit - Finalize changes with a commit message" \
        "squash - Merge current work into parent commit" \
        "abandon - Discard current changes safely" \
        "new - Create a new revision from any bookmark" \
        "bookmark - Manage existing bookmarks" \
        "branch - Create new branch with fresh revision" \
        "remote - Push, pull, and manage remote repositories" \
        "exit - Exit the script" \
        --header "Choose your action:" | cut -d' ' -f1)

  case "$action" in
  new)
    if gum confirm "Do you want to create a new revision"; then
    newCommitBase=$(jj bookmark list | sed 's/:.*//' | gum choose --header="Choose a branch to commit")
    jj new "$newCommitBase"
    echo
    fi
  ;;
  commit)
    MESSAGE=$(gum input --placeholder "Final commit message")
    if [ -n "$MESSAGE" ]; then
      jj commit -m "$MESSAGE"
      echo
      bookmark=$(jj bookmark list | sed 's/:.*//' | gum choose --header="Choose a branch to commit")
      if [ -n "$bookmark" ]; then
        jj bookmark move "$bookmark" --from "$bookmark" --to @-
        echo
        echo "Committed to $bookmark"
      else
        echo "No branch selected."
      fi
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Created a new commit'
      
      # Check if remotes exist and ask to push
      if jj git remote list | grep -q .; then
        if gum confirm "Push '$bookmark' to remote?"; then
          # Check if multiple remotes exist
          remote_count=$(jj git remote list | wc -l)
          if [ "$remote_count" -gt 1 ]; then
            selected_remote=$(jj git remote list | sed 's/ .*//' | gum choose --header="Choose remote to push to:")
            if [ -n "$selected_remote" ]; then
              jj git push -b "$bookmark" --remote "$selected_remote" --allow-new
            fi
          else
            jj git push -b "$bookmark" --allow-new
          fi
          echo
          gum style \
            --foreground 121 \
            --align left --width 40 --margin "2 2" \
            "📤 Pushed '$bookmark' to remote"
        fi
      fi
    else
      echo "No message entered."
    fi
    ;;
  squash)
    if gum confirm "Do you want to squash the current work into the parent commit"; then
      jj squash
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Squashed work to parent'
    fi
    ;;
  bookmark)
      bookmark_action=$(gum choose \
          "move - Relocate existing bookmark to different revision" \
          "create - Create new bookmark at specific revision" \
          "delete - Remove an existing bookmark" \
          --header "Choose bookmark action:" | cut -d' ' -f1)
      case "$bookmark_action" in
        move)
          bookmark_source=$(jj bookmark list | sed 's/:.*//' | gum choose --header="Choose a bookmark to move")
          echo "you are moving the bookmark $bookmark_source"
          bookmark_destination=$({ jj bookmark list | sed 's/:.*//'; printf "@\n@-\n"; } | gum choose --header="Choose where to move the bookmark")
          echo
          jj bookmark move -f "$bookmark_source" -t "$bookmark_destination"
      esac
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Moved a bookmark'
    ;;
  remote)
      while true; do
          # Check if remotes exist and show appropriate menu
          if jj git remote list | grep -q .; then
              # Show full menu when remotes exist
              remote_action=$(gum choose \
                  "push - Push a bookmark to remote" \
                  "pull - Fetch changes from remote" \
                  "list - Display all configured remotes" \
                  "add - Add a new remote for existing repo" \
                  "remove - Remove an existing remote" \
                  "create - Create new GitHub repo and push" \
                  "back - Return to main menu" \
                  --header "Choose a remote action:" | cut -d' ' -f1)
          else
              # Show limited menu when no remotes exist
              remote_action=$(gum choose \
                  "add - Add a new remote for existing repo" \
                  "create - Create new GitHub repo and push" \
                  "list - Display all configured remotes" \
                  "back - Return to main menu" \
                  --header "No remotes found. Choose an action:" | cut -d' ' -f1)
          fi
      case "$remote_action" in
          push)
              push_source=$(jj bookmark list | grep -v '^\s*@' | sed 's/:.*//' | gum choose --header="Choose a bookmark to push")
              remote_destination=$({ jj git remote list | sed 's/ .*//'; printf "new branch"; } | gum choose --header="Choose a remote branch")
              if [[ $remote_destination == *new* ]]; then
                  jj git push -b "$push_source" --allow-new
                  echo
              else
                  jj git push -b "$push_source" --remote "$remote_destination"
                  echo
              fi
              gum style \
                  --foreground 121 \
                  --align left --width 40 --margin "2 2" \
                  "📤 Pushed bookmark \"$push_source\" to remote branch \"$remote_destination\""
              break
              ;;
          pull)
              jj git pull
              echo
              jj log --limit 3
              gum style \
                  --foreground 121 \
                  --align left --width 40 --margin "2 2" \
                  '🔄 Pulled from remote'
              break
              ;;
          add)
              new_remote_name=$(gum input --header="Add a new remote" --placeholder="Choose remote name")
              new_remote_url=$(gum input --header="Input remote SSH URL" --placeholder="git@github.com:<USER>/<REPO>.git")
              if [ -n "$new_remote_name" ] && [ -n "$new_remote_url" ]; then
                  jj git remote add "$new_remote_name" "$new_remote_url"
                  echo
                  jj git remote list
                  gum style \
                      --foreground 121 \
                      --align left --width 40 --margin "2 2" \
                      "✅ Added remote $new_remote_name"
              else
                  echo "❌ Remote name or URL not provided. Canceled."
              fi
              break
            ;;
          remove)
              remote_to_remove=$(jj git remote list | sed 's/ .*//' | gum choose --header="Choose a remote to remove")
              if [ -n "$remote_to_remove" ]; then
                  if gum confirm "Do you want to remove remote '$remote_to_remove'?"; then
                      jj git remote remove "$remote_to_remove"
                      echo
                      jj git remote list
                      gum style \
                          --foreground 121 \
                          --align left --width 40 --margin "2 2" \
                          "✅ Removed remote $remote_to_remove"
                  else
                      echo "❌ Remote removal canceled."
                  fi
              else
                  echo "❌ No remote selected."
              fi
              break
              ;;
          create)
              # Get GitHub username
              github_user=$(gh api user --jq '.login')
              if [ $? -ne 0 ] || [ -z "$github_user" ]; then
                  echo "❌ Error: Could not get GitHub username. Check your authentication."
                  exit 1
              fi
              
              # Ask for repo name
              repo_name=$(gum input --header="Create GitHub repository" --placeholder="Enter repository name")
              if [ -z "$repo_name" ]; then
                  echo "❌ No repository name provided. Canceled."
                  continue
              fi
              
              # Ask for visibility
              visibility=$(gum choose \
                  "private - Repository visible only to you and collaborators" \
                  "public - Repository visible to everyone on GitHub" \
                  --header "Repository visibility:" | cut -d' ' -f1)
              visibility_flag=""
              if [ "$visibility" = "public" ]; then
                  visibility_flag="--public"
              else
                  visibility_flag="--private"
              fi
              
              # Create the repository
              echo "Creating repository $github_user/$repo_name..."
              if gh repo create "$repo_name" $visibility_flag; then
                  echo
                  # Add as remote
                  remote_url="git@github.com:$github_user/$repo_name.git"
                  jj git remote add origin "$remote_url"
                  echo
                  
                  # Ask which bookmark/branch to push
                  push_source=$(jj bookmark list | grep -v '^\s*@' | sed 's/:.*//' | gum choose --header="Choose a bookmark to push to new repo")
                  if [ -n "$push_source" ]; then
                      if gum confirm "Push '$push_source' to the new GitHub repository?"; then
                          jj git push -b "$push_source" --allow-new
                          echo
                          gum style \
                              --foreground 121 \
                              --align left --width 50 --margin "2 2" \
                              "✅ Created repo $github_user/$repo_name and pushed $push_source"
                      fi
                  fi
              else
                  echo "❌ Error: Failed to create repository. It may already exist."
              fi
              break
              ;;
          list)
              echo "Current remotes:"
              jj git remote list
              if ! jj git remote list | grep -q .; then
                  echo "No remotes configured."
              fi
              echo
              gum style \
                  --foreground 121 \
                  --align left --width 40 --margin "2 2" \
                  'ℹ️ Listed all remotes'
              # Continue loop to stay in remote menu
              ;;
          back)
              break
              ;;
          *)
              echo "❌ Canceled action"
              break
              ;;
        esac
      done
      ;;
  abandon)
    if gum confirm "Do you want to abandon the current work"; then
      jj abandon --retain-bookmarks
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '🗑️ Abandoned current work'
    fi
    ;;
  branch)
    if gum confirm "Do you want to create a new branch?"; then
      BOOKMARK=$(gum input --placeholder "Name your branch")
      jj new @-
      echo
      jj bookmark create "$BOOKMARK" -r @-
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Created a new branch'
    fi
    ;;
  exit)
    break
    ;;
  *)
    echo "❌ No action taken!"
    ;;
  esac
  done
  
  exit 0

# Case 4: Both .jj and .git exist colocate
elif $has_jj && $has_git; then

  jj st
  echo

  action=$(gum choose \
      "commit - Create commits with Git branch synchronization" \
      "squash - Squash changes while maintaining Git compatibility" \
      "abandon - Safely discard changes in both systems" \
      --header "Choose your action:" | cut -d' ' -f1)

  case "$action" in
  commit)
    MESSAGE=$(gum input --placeholder "Final commit message")
    BRANCH=$(git branch --show-current)
    if [ -n "$MESSAGE" ]; then
      jj commit -m "$MESSAGE"
      echo
      jj bookmark move --from 'heads(::@- & bookmarks())' --to @-
      echo
      git switch "$BRANCH"
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Created a new commit'
      
      # Check if remotes exist and ask to push
      if jj git remote list | grep -q .; then
        if gum confirm "Push '$BRANCH' to remote?"; then
          # Check if multiple remotes exist
          remote_count=$(jj git remote list | wc -l)
          if [ "$remote_count" -gt 1 ]; then
            selected_remote=$(jj git remote list | sed 's/ .*//' | gum choose --header="Choose remote to push to:")
            if [ -n "$selected_remote" ]; then
              jj git push -b "$BRANCH" --remote "$selected_remote" --allow-new
            fi
          else
            jj git push -b "$BRANCH" --allow-new
          fi
          echo
          gum style \
            --foreground 121 \
            --align left --width 40 --margin "2 2" \
            "📤 Pushed '$BRANCH' to remote"
        fi
      fi

    else
      echo "No message entered."
    fi
    exit 0
    ;;
  squash)
    if gum confirm "Do you want to squash the current work into the parent commit"; then
      BRANCH=$(git branch --show-current)
      jj squash
      echo
      git switch "$BRANCH"
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '✅ Squashed work to parent'
    fi
    ;;
  abandon)
    if gum confirm "Do you want to abandon the current work"; then
      jj abandon --retain-bookmarks
      echo
      jj log --limit 3
      gum style \
        --foreground 121 \
        --align left --width 40 --margin "2 2" \
        '🗑️ Abandoned current work'
    fi
    ;;
  *)
    echo "❌ No action taken!"
    ;;
  esac

  exit 0

fi
