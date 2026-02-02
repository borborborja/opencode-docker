# OpenCode Docker

A versatile, auto-updating Docker image for [OpenCode AI](https://opencode.ai).

## Features
- **Auto-update**: Installs/updates OpenCode on every container start.
- **Rich Tooling**: Includes `python`, `nodejs`, `git`, `ripgrep`, `jq`, `yq`, and more.
- **Persistent Storage**: Separates configuration from project code.
- **Healthchecks**: Integrated monitoring for the web interface.

## Quick Start

1. **Clone the repo**:
   ```bash
   git clone https://github.com/borborborja/opencode-docker.git
   cd opencode-docker
   ```

2. **Configure API Keys**:
   ```bash
   cp .env.example .env
   # Edit .env with your keys
   ```

3. **Run**:
   ```bash
   docker-compose up -d
   ```

4. **Access**:
   Open `http://localhost:4096` in your browser.

## Volumes
- `./projects`: Your code goes here (mounted to `/app`).
- `opencode-data`: Internal volume for OpenCode settings and LLM keys.

## CI/CD
This repository includes a GitHub Action to build and push the Docker image to Docker Hub.
Requires the following GitHub Secrets:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
