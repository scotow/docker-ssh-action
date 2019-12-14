#!/bin/sh

set -euo pipefail

if [[ -z "$INPUT_REMOTE_HOST" ]]; then
    echo 'Invalid REMOTE_HOST'
    exit 1
fi

if [[ -z "$INPUT_REMOTE_USER" ]]; then
    echo 'Invalid REMOTE_USER'
    exit 1
fi

if [[ -z "$INPUT_REMOTE_SSH_PUBLIC_KEY" ]]; then
    echo 'Invalid REMOTE_PUBLIC_KEY'
    exit 1
fi

if [[ -z "$INPUT_REMOTE_SSH_PROTO" ]]; then
    echo 'Invalid INPUT_REMOTE_SSH_PROTO'
    exit 1
fi

if [[ -z "$INPUT_SSH_PRIVATE_KEY" ]]; then
    echo 'Invalid SSH_PRIVATE_KEY'
    exit 1
fi

echo -n "$INPUT_REMOTE_HOST"           >  /etc/ssh/ssh_known_hosts
echo    "$INPUT_REMOTE_SSH_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts

mkdir -p "$HOME/.ssh"

echo -e "Host $INPUT_REMOTE_HOST"                       >  "$HOME/.ssh/config"
echo -e "  HostName $INPUT_REMOTE_HOST"                 >> "$HOME/.ssh/config"
echo -e "  User $INPUT_REMOTE_USER"                     >> "$HOME/.ssh/config"
echo -e "  IdentityFile ~/.ssh/remote"                  >> "$HOME/.ssh/config"
echo -e "  HostKeyAlgorithms $INPUT_REMOTE_SSH_PROTO"   >> "$HOME/.ssh/config"

echo "$INPUT_SSH_PRIVATE_KEY" > "$HOME/.ssh/remote"

chmod 400 "$HOME/.ssh/config" "$HOME/.ssh/remote"

docker -H "ssh://$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST" "$@" 2>&1