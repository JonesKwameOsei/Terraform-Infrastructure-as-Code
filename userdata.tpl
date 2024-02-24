#!/bin/bash

# Update package lists and install prerequisites
sudo apt-get update -y && \
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \

# Update package lists again
sudo apt-get update -y && \

# Install Docker packages
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io && \

# Add current user to the docker group
sudo usermod -aG docker "$(whoami)"
 




