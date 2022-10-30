#!/usr/bin/env bash

# Add group
groupadd -g "$DEVS_GID" "$DEVS_GROUP"

# Add user
useradd -u "$DEVS_UID" --home "/home/txtdevs" --create-home --shell /bin/bash --no-user-group "$DEVS_USER"

# Assign user to group
usermod -g "$DEVS_GROUP" "$DEVS_USER"
