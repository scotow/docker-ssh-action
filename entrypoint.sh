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

if [[ -n "$GITHUB_REPOSITORY" -a -n "$INPUT_GITHUB_TOKEN" ]]; then
    echo 'Loging in to GitHub Docker repo'
    USER=$(cut -d/ -f1 <<< $GITHUB_REPOSITORY)
    docker login docker.pkg.github.com -u $USER -p $INPUT_GITHUB_TOKEN
fi

echo -n "$INPUT_REMOTE_HOST "          >  /etc/ssh/ssh_known_hosts
echo    "$INPUT_REMOTE_SSH_PUBLIC_KEY" >> /etc/ssh/ssh_known_hosts

mkdir -p "/root/.ssh"

echo "Host $INPUT_REMOTE_HOST"                       >  "/root/.ssh/config"
echo "  HostName $INPUT_REMOTE_HOST"                 >> "/root/.ssh/config"
echo "  User $INPUT_REMOTE_USER"                     >> "/root/.ssh/config"
echo "  IdentityFile ~/.ssh/remote"                  >> "/root/.ssh/config"
echo "  HostKeyAlgorithms $INPUT_REMOTE_SSH_PROTO"   >> "/root/.ssh/config"

echo "$INPUT_SSH_PRIVATE_KEY" > "/root/.ssh/remote"

chmod 400 "/root/.ssh/config" "/root/.ssh/remote"

docker -H "ssh://$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST" "$@"