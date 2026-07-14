# obsidian-vault-mcp

Run a headless, continuously-syncing Obsidian vault in Docker, and expose it to
LLMs/agents over the network via an MCP server ([`@bitbonsai/mcpvault`](https://www.npmjs.com/package/@bitbonsai/mcpvault))
fronted by [`supergateway`](https://github.com/supercorp-ai/supergateway).

Two containers, built from the same image:

- **`obsidian-sync`** — runs [`obsidian-headless`](https://www.npmjs.com/package/obsidian-headless) (`ob sync --continuous`), keeping a local copy of your vault in sync with Obsidian Sync.
- **`obsidian-mcp`** — serves that vault as an MCP server over streamable HTTP on port `3000`, so any MCP-capable client on your network (or tailnet) can read/write notes.

This is designed to run on something small and always-on, like a Raspberry Pi.

## Prerequisites

- Docker and Docker Compose
- An Obsidian account with [Obsidian Sync](https://obsidian.md/sync) enabled on the vault you want to expose
- An API key for the REST/local-API plugin your MCP server expects (see `.env.example`)

## Setup

1. Copy the env template and fill in your values:
   ```sh
   cp .env.example .env
   ```
2. Run the interactive setup script. This logs in to Obsidian Sync, lists your remote vaults, binds the local `./vault` folder to the one you choose, and pulls an initial copy:
   ```sh
   chmod +x setup.sh
   ./setup.sh
   ```
   `./vault` and `./config` are created on first run and are git-ignored — they hold your actual notes and auth tokens, and never belong in version control.
3. Start both services:
   ```sh
   docker compose up -d
   ```
4. The MCP server is now reachable at `http://<host>:3000`. Point your MCP client at it, using the same `OBSIDIAN_API_KEY` from your `.env` file.

## Notes

- `obsidian-sync` keeps `./vault` current in the background; `obsidian-mcp` just reads/writes files under that same folder, so the two stay consistent without any extra glue.
- Never commit `.env`, `./vault`, or `./config` — they contain your credentials and personal notes. This repo's `.gitignore` already excludes them.
- If you rotate your API key, update `.env` and run `docker compose up -d` again to pick it up.
