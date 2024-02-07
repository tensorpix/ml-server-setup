# Machine Learning Server Setup (MLSS)

This is a script that can quickly get you up and running for running any ML or DL workload. It's designed to be minimally interactive.

## ❓ What does the script do

- Updates system packages
- Adds basic packages such as python3, git, venv, tmux...
- Installs NVIDIA driver
- Installs NVIDIA container toolkit. This enables CUDA inside docker containers.
- Installs Docker + Docker Compose
- Installs tensorboard and nvitop

## Requirements

Your user must have sudo permissions to run the script.

The script was tested on the following systems:

- Ubuntu Server 22.04

## ⚙️ Running the script

1. Open the `setup.sh` and change the variables at the top.
2. Run it: `./script.sh`
