#!/bin/bash

VM_ID=$1
VM_CLONE_ID=$2
qm stop $VM_CLONE_ID && qm destroy $VM_CLONE_ID
qm clone $VM_ID $VM_CLONE_ID --name ubuntu2004-cloud-template-ansible-clone --full >/dev/null 2>&1
qm start $VM_CLONE_ID
#[How to ping in linux until host is known?](https://serverfault.com/questions/42021/how-to-ping-in-linux-until-host-is-known)
VM_IP='192.168.1.42'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
# waits for sshd
until nc -vzw 2 $VM_IP  22 >/dev/null 2>&1; do sleep 2; echo -e "..${MAGENTA}PING${NC}"; done; echo -e "--> ${GREEN}DONE${NC}"
