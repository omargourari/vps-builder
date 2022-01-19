#!/bin/bash -x -a

# Remove ANSI color codes from log.txt file
gsed -i 's/\x1b\[[0-9;]*m//g' ./log.txt

export LOCAL_USER=$(grep -o 'Local User:   \[.*' ./log.txt | grep -o '\[[^][]*]' | sed 's/\[//;s/\]//')
export NORM_USER_NAME=$(grep -o 'User Name:   \[.*' ./log.txt | grep -o '\[[^][]*]' | sed 's/\[//;s/\]//')
export PRIVATE_KEY=$(awk '/\-----BEGIN OPENSSH PRIVATE KEY-----/,/\-----END OPENSSH PRIVATE KEY-----/' ./log.txt)
export PUBLIC_KEY=$(awk '/^ssh-ed255/' ./log.txt)
export SERVER_NICK_NAME=$(grep -o 'Server Nick Name:   \[.*' ./log.txt | grep -o '\[[^][]*]' | sed 's/\[//;s/\]//')
export SERVER_IP=$(grep -o 'Server IP:   \[.*' ./log.txt | grep -o '\[[^][]*]' | sed 's/\[//;s/\]//')
export SSH_CONFIG=$(awk '/__START SSH NEW CONFIG__/,/__END SSH NEW CONFIG__/' ./log.txt | sed '1d; $d')

# Write private key file to new file
echo "${PRIVATE_KEY}" > /Users/${LOCAL_USER}/.ssh/${NORM_USER_NAME}
chmod 400 /Users/${LOCAL_USER}/.ssh/${NORM_USER_NAME}
# Write public key file to new file
echo "${PUBLIC_KEY}" > /Users/${LOCAL_USER}/.ssh/${NORM_USER_NAME}.pub
chmod 400 /Users/${LOCAL_USER}/.ssh/${NORM_USER_NAME}.pub
# Remove from line "Host ${SERVER_NAME}"
sed -i.bak '/Host ${SERVER_IP}/,/^$/d' /Users/${LOCAL_USER}/.ssh/config
# Adde new config in ~/.ssh/config
echo "\n ${SSH_CONFIG}" >> /Users/${LOCAL_USER}/.ssh/config
# Remove last line of .ssh/know_hosts file
sed -i '$ d ' /Users/${LOCAL_USER}/.ssh/known_hosts
# Add shortcut to .zshrc file
echo "\nalias ${SERVER_NICK_NAME}=\"ssh ${SERVER_IP}\"" >> /Users/${LOCAL_USER}/.zsh/.zshrc
# source /Users/${LOCAL_USER}/.zsh/.zshrc
# Log back in as new user
# ${SERVER_NICK_NAME}