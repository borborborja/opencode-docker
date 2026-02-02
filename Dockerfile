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

# Install yq (YAML processor)
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

# Set working directory
WORKDIR /app

# Ensure OpenCode binary is in the PATH
ENV PATH="/root/.opencode/bin:${PATH}"

# Pre-install OpenCode during build to speed up container start
RUN curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the default port
EXPOSE 4096

# Define environment variable to signal it's running in Docker
ENV IN_DOCKER=true

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
