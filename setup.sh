#!/bin/bash

TIMEZONE="Europe/Zagreb"
NVIDIA_VERSION="535"

sudo timedatectl set-timezone $TIMEZONE

sudo apt update && sudo apt upgrade -y

sudo apt install \
	ubuntu-drivers-common \
	htop \
	python3-pip \
	python3-venv \
	git \
	vim

sudo pip install --no-cache-dir \
	nvitop==1.* \
	tensorboard==2.*

# NVIDIA drivers
# https://ubuntu.com/server/docs/nvidia-drivers-installation
sudo ubuntu-drivers install nvidia:$NVIDIA_VERSION-server
sudo apt install -y nvidia-utils-$NVIDIA_VERSION-server

# Docker + docker compose
sudo apt-get -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
echo "User $USER added to the 'docker' group."
echo "Remember to add other users to the 'docker' group!"

# NVIDIA container toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker


echo "Please reboot the system to finish the setup script."