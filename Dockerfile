# Use Ubuntu as a base for broad tool support and apt availability
FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install a wide variety of tools for agent versatility
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    unzip \
    tar \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    jq \
    htop \
    net-tools \
    iputils-ping \
    dnsutils \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode via NPM (most stable method for Docker)
RUN npm i -g opencode-ai@latest

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory
WORKDIR /app

# Ensure standard binary path is reachable
RUN ln -sf /usr/local/bin/opencode-ai /usr/local/bin/opencode || true

# Expose the default port
EXPOSE 4096

# Define environment variable to signal it's running in Docker
ENV IN_DOCKER=true

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
