#!/usr/bin/env bash
set -euo pipefail

# Clear out any incomplete config from previous attempts
rm -rf config/*

# 1. Run interactive login (token gets written to ./config/obsidian-headless/)
UID=$UID GID=$GID docker compose run --rm obsidian-sync ob login

# 2. Check remote vaults list to confirm authentication profile is active
UID=$UID GID=$GID docker compose run --rm obsidian-sync ob sync-list-remote

# 3. Bind the local volume folder to your vault endpoint
#    Replace "Your Remote Vault Name" with the vault name from step 2.
UID=$UID GID=$GID docker compose run --rm obsidian-sync ob sync-setup --vault "Your Remote Vault Name"

# 4. Trigger initial data download clone
UID=$UID GID=$GID docker compose run --rm obsidian-sync ob sync
