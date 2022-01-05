#!/bin/bash
VM_IP='192.168.1.42'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
# waits for sshd
# until nc -vzw 2 $VM_IP  22 >/dev/null 2>&1; do sleep 2; echo -e "..${MAGENTA}PING${NC}"; done; echo -e "--> ${GREEN}DONE${NC}"
until nc -vzw 2 $VM_IP 22 >/dev/null 2>&1; 
do 
  sleep 2; 
  echo -e "..${MAGENTA}PING${NC}";
done; 
echo -e "--> ${GREEN}DONE${NC}"
exit 0
