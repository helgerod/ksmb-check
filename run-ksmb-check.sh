#!/bin/bash

#
# Check if kernel version is potentially vulnerable to ksmbd vulnerability 
# (CVE-2022-47938, CVE-2022-47939, CVE-2022-47940, CVE-2022-47941, CVE-2022-47942 and CVE-2022-47943).
# Vulnerable kernel verions: 5.15.x (minor that 5.15.61), 5.16.x, 5.17.x, 5.18.x and 5.19.x (minor that 5.19.2)
# Author: Rafael Santos <rafaelns@gmail.com>
#

# Set terminal colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

# Get kernel version
IFS=$'.- \t\n' read MAJOR MINOR RELEASE TRASH <<< `uname -r`

# Test using a kernel version received from command line (mocking)
[ -n "$1" ] && IFS=$'.- \t\n' read MAJOR MINOR RELEASE TRASH <<< "$1"

# Check if discovery kernel version sucessfully
if [ -z "${MAJOR}" ] || [ -z "${MINOR}" ] || [ -z "${RELEASE}" ]; then
  echo "ERROR: Error discovering your kernel version. Aborting"
  exit 1
fi
echo "Kernel version: ${MAJOR}.${MINOR}.${RELEASE}"

# Check major an minor kernel version
echo "Checking ksmbd vulnerability..."
if [ ${MAJOR} -ne 5 ] \
|| [ ${MINOR} -lt "15" -o ${MINOR} -gt "19" ]; then
  echo -e "\n${GREEN}SAFE: Kernel version is not vulnerable.${NC}"
  exit 0
fi

# Check if is a fixed kernel version
if [ "${MAJOR}.${MINOR}" == "5.15" -a ${RELEASE} -ge 61 ] \
|| [ "${MAJOR}.${MINOR}" == "5.19" -a ${RELEASE} -ge  2 ]; then
  echo -e "\n${GREEN}SAFE: Your kernel is updated and is not vulnerable."
  exit 0
fi

# If kernel >= 5.15.0 (but minor then 5.15.61) and <= 5.19.1
echo -e "${YELLOW}WARNING: Your kernel is potentially vulnerable! I will do a deeper inspection...${NC}"

# Check if ksmbd module exist
if [ -z "`modinfo ksmbd 2>/dev/null`" ]; then
  echo -e "\n${GREEN}SAFE: Your kernel has no ksmbd module and is not vulnerable.${NC}"
  exit 0
fi
echo -e "  |_${YELLOW}WARNING: Your kernel has the ksmbd module and is potentially vulnerable! I will do a deeper inspection...${NC}"

# Check if ksmbd module is loaded in kernel
if [ -z "`lsmod  | grep ksmbd`" ]; then
  echo -e "\n${GREEN}SAFE: The module ksmbd isn't loaded in kernel.${NC}"
  exit 0
fi
echo -e "\n${RED}PANIC: ksmbd module is potentially vulnerable and is loaded in your kernel! Try to remove it using the command:\nmodprobe -r ksmbd  # Use sudo or a credential with root privilegies${NC}"