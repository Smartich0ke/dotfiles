#!/usr/bin/bash

sudo snap install bw

bw config server https://bitwarden.artichokenetwork.com

# You are already logged in with any method
export BW_SESSION=$(bw unlock --raw)

# You are not logged in and log in with an email
export BW_SESSION=$(bw login $BITWARDEN_EMAIL --raw)

bw sync