#!/bin/bash

#################################
# Author:       Matej Ciglenečki
# Description:  Script that sets up a new user on the system.

# Script should be run as root.
# Script should be idempotent. Running it multiple times should not have any side effects.
# Script should be run with the username of the new user as the first argument.

# Usage example:
# sudo ./create_user.sh newuser
#################################


# Check if script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

# Check if username is provided
if [ -z "$1" ]; then
    echo "Error: username of the new user is the first argument."
    exit 1
fi

NEWUSER=$1
COMPANY_GROUP_GID=1004
COMPANY_GROUP_NAME="tensorpix"


# Create company group if it doesn't exist
if ! getent group "$COMPANY_GROUP_NAME" >/dev/null; then
    echo "Creating group $COMPANY_GROUP_NAME (GID $COMPANY_GROUP_GID)"
    groupadd -g $COMPANY_GROUP_GID $COMPANY_GROUP_NAME
fi


# Create user if it doesn't exist
if id "$NEWUSER" >/dev/null 2>&1; then
    echo "User $NEWUSER already exists"
else
    echo "Creating user $NEWUSER"
    adduser --disabled-password --gid $COMPANY_GROUP_GID --shell /bin/bash --gecos ""  $NEWUSER
fi


# Add user groups
usermod -aG $COMPANY_GROUP_NAME $NEWUSER
usermod -aG docker $NEWUSER


# Setup ssh directory
HOME_DIR="/home/$NEWUSER"
mkdir -p $HOME_DIR/.ssh
touch $HOME_DIR/.ssh/authorized_keys
chown -R $NEWUSER:$COMPANY_GROUP_NAME $HOME_DIR
chmod 700 $HOME_DIR
chmod 700 $HOME_DIR/.ssh
chmod 600 $HOME_DIR/.ssh/authorized_keys


echo "Call to action: add public key to /home/$NEWUSER/.ssh/authorized_keys"
echo "Call to action: tell $NEWUSER to change their password with 'passwd' command"
