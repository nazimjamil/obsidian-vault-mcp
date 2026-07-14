FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g obsidian-headless

RUN npm install -g supergateway

RUN mkdir -p /home/node/.config /home/node/vault && chown -R node:node /home/node

USER node
WORKDIR /home/node/vault

CMD ["ob", "sync", "--continuous"]
