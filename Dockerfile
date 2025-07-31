# For more information, please refer to https://aka.ms/vscode-docker-python
FROM mcr.microsoft.com/devcontainers/python:3.12
USER root

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python \
    UV_LINK_MODE=copy \
    UV_INSTALL_DIR=/app \
    PATH="$PATH:/app"

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install utils
RUN apt-get update && apt-get install -y build-essential --no-install-recommends \
    ca-certificates \
    git \
    wget \
    curl \
    libxml2-utils \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY ./.devcontainer/starship.sh /root/starship.sh
RUN mkdir -p /root/.config
COPY ./.devcontainer/starship.toml /root/.config/starship.toml
RUN chmod +x /root/starship.sh \
    && /root/starship.sh -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc

RUN uv sync --all-packages