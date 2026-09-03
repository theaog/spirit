## 3481a
- brutekey: quick one-liner — `./spirit brutekey root@1.2.3.4` (add `:port` for a custom port; repeat for several targets, no files needed)
- brutekey: one-off usernames without a file — `--usernames root,admin`
- brutekey: the users file is simpler — plain usernames (one per line) now work, and the same user is never tried twice; `USER:PASS` still works but the password part is ignored
- brutekey: a missing `p.lst` no longer stops the run (same as `brute`) — the built-in user list is used
- brutekey: feed hosts from a pipe — `./spirit scan ... | ./spirit brutekey --hosts -`
- brutekey: uses all your SSH keys automatically — the one(s) set with `--file`, every private key kept in `~/.ssh`, and every key your ssh-agent holds; the same key is never tried twice
- brutekey: keys are shown before the attack starts (file, origin, fingerprint) so you always know which keys will be tried
- brutekey: privacy switches — `--only` (use only `--file` keys), `--no-ssh-dir` and `--no-agent` (skip keys from those places)
- brutekey: `--file` accepts several keys at once — `--file id_rsa,deploy.pem`
- brutekey: shows a clear error if no usable key is found at all
- brutekey: shows the plan before starting (users × keys × hosts = attempts) and `--dry-run` shows it without attacking
- brutekey: live progress bar with a Found counter; Ctrl-C finishes safely and saves results
- brutekey: clear end summary (successful logins and connection failures)
- brutekey: friendlier errors — a missing `b.lst` tells you how to fix it instead of a cryptic message
- brutekey: `--fail-on-found` exits with an error code when a key worked, so scripts can react
- brutekey: failed key attempts no longer flood the screen with red errors — failures are counted and shown in the end summary; use the debug flag if you want every detail
- brutekey: starts faster (removed an unnecessary 2-second wait)

## 4d7ed
- scan: positional targets — `./spirit scan 192.168.1.0/24`, `./spirit scan 10.0.0-9.*`, `./spirit scan 192` or a single IP, no flags needed
- scan: `--file` now works (one IP per line, `#` comments) and accepts `-` to read from a pipe: `cat ips.txt | ./spirit scan --file -`
- scan: results now append to the output file with a date header instead of wiping your previous results
- scan: `--output FILE` to choose where results go (default `h.lst`)
- scan: Ctrl-C is now safe — it stops the scan, finishes pending checks and shows a partial summary; your results are saved
- scan: open ports print as clean `host:port` lines on stdout — pipe them anywhere; use `--json` for JSON lines
- scan: start banner shows the size of what you asked for: hosts × ports = checks, threads and timeout
- scan: `--dry-run` shows exactly what would be scanned before you commit
- scan: huge scans (>5M checks) ask for confirmation; use `--yes` to skip the prompt
- scan: `--exclude 10.0.0.0/8,1.2.3.4,@infra.txt` protects your own servers and ranges from the scan
- scan: `--ports lan` preset checks the 23 most useful LAN ports instead of just 22
- scan: port ranges supported: `--ports 1000-2000` or `--ports all` (1–65535), duplicate ports are ignored
- scan: `--fail-on-open` exits with code 1 if any port is open — handy for scripts
- scan: end summary now shows how long the scan took
- scan: fixed wrong host counts — `--local all` no longer scans two private ranges twice (~1.1M wasted checks)
- scan: fixed bad ranges like `11.5-5.*.*` being silently accepted as empty
- scan: fixed invalid ports like `--ports abc` dialing a broken address instead of erroring
- scan: fixed a crash on short `--range` values like `11.1-200.*`
- scan: `--threads 0` no longer freezes the scan
- scan: unreachable hosts are no longer retried when the port is clearly closed — scans of closed networks finish roughly twice as fast

## Spirit 1.31
- brute: Ctrl-C now stops in-flight SSH connections immediately via context-aware cancellation, no more waiting for timeouts
- brute: output directory is now stable — `found.*` files always land where the command was launched, even if the process changes directories mid-run
- brute: added support for cast128-cbc, idea-cbc, rijndael-cbc, hmac-md5, hmac-md5-96 ciphers/MACs — reaches more legacy Cisco, Juniper, and embedded devices
- brute: connection failure statistics now printed on screen at the end of every run (in addition to `found.errors`)
- brute: connection failure statistics sent to Telegram as a separate message when `--tgkey`/`--tgchan` is configured
- brute: cancelled connections (Ctrl-C) no longer count as failures for the host-blocking/blacklisting logic
- brute: added live-updating "Finishing connections" progress bar during drain/shutdown phase
- brute: fixed goroutine leak — internal monitoring goroutines now bounded to each connection's lifetime
- brute: fixed `split_host` panic on IPv6 addresses like `[::1]:22`
- brutekey: added proper context cancellation, drain UX, and connection stats output (parity with brute)

## Spirit 1.30
- NEW: proxy-banner: faster, more accurate and handsome -- with Terminal UI
- NEW: encrypt: make an AES256/GCM encrypted version of your p.lst passfile
- added license reset limits (24 resets)
- updated flags for `scan`: ./spirit scan --help
- secured input for license key during register and reset to avoid leaking key shell history
- added spirit arm64 and i386 compiled binaries
- changed omni to auto-ssh
- added threads/timeout to auto-ssh
- added Nmap parsing of open.lst to ./spirit parse
- redesigned `parse` command: faster, supports nmap,masscanv1,masscan>v1 -oG parsing
- fixed an issue where parse would output wrong format on old masscan syntax
- FIX: issue where brute would waste 1s every blocked host, now moves faster
- removed Basic/Pro/Ultra version segregation, now Spirit is an all-in-one tool
- improved brute, fixed hangout bug on 0 hosts
- redesigned file handling open.lst > h.lst > b.lst > found.lst
- added deterministic hosts randomization
- banner now appends to b.lst
- improved BLOCK accuracy during honey-pot scan, improving speed
- improved NOLOGIN detection, they will be stored in separate `found.nologin` file
- found.nologin can be used with autossh to verify the nologins detection is accurate
- removed auto-threads limitations, you now have full control
- SSH connection errors are now being stored in `found.errors`
- autobanner can now use proxybrute via --proxy flag
- added Spirit beta: ./spirit upgrade --beta for latest versions
- improved spirit buy w/ ability to design your own licensing plan
- spirit Bot now let's you run Spirit commands within IRC channels: .spirit scan --lan 
- partners can now check their sales: `./spirit partner sales <code> or shortform: ./spirit pp s <code>`
- removed license requirement for upgrade functionality
- brute: added sending found.ssh data via telegram while scan is in progress
- added output streaming to .spirit/.shell bot command
- changed spirit scan output from scan.lst to h.lst
- nologins won't display on Found[n] hud
- banner will now display skipped hosts via filter.lst file
- proxybanner: fixed an issue where a crash would occur w/ very large host files

## Spirit 1.29
- renamed `forever` to `auto-brute` which uses masscan on a list of CIDRs on random ports and brutes them automatically then repeats
- removed Warn print when a host is Found
- created Spirit Community telegram channel
- added ability to join community via `./spirit partner`
- fixed issues w/ auto-brute
- improved banner speed by 50%
- added more Ciphers, Key exchange algos and Macs to SSH
- renamed `jobs` to `threads`
- added brute specific threads & timeout flags
- new flags: -t for Threads and -T for timeout

## Spirit 1.28
- fixed an issue where brute might get stuck when hosts are less than 5
- improved TRIAL mode
- improved spirit buy, added features list
- added display of Open connections limits
- added auto-rlimit
- improved brute -- 30% more found.lst hosts
- added cve-gitlab exploit to ultra
- scan: can now specify multiple networks using comma --local 172,192

## Spirit 1.27
- new licensing server
- new Spirit Partner Program
- new table outlining plan features in ./spirit buy
- new Ultra license (under development)
- new encryption option for p.lst and found.lst files (Ultra only)
- fixed licensing bug on servers w/o internet
- fixed Basic license issuing spirit Pro
- fixed sporadic DB lock issue
- fixed an issue where sometimes old licenses would conflict w/ new ones when registering a server
- general improvements

## Spirit 1.26
- improved scan command
- updated all deps to latest
- added exploit command w/ CVE-2021-4034 & CVE-2018-14655 (./spirit exploit)
- added zimbra exploit CVE_2019_9670 (./spirit ex zimbra URL)
- improved brute efficiency
- added more statistics to brute
- added automatic changing threads wile running
- removed --filter flag from banner
- added `filter.lst` file to load SSH banner filters
- made brute-key work under classic spirit license, was only available in Pro
- reduced maximum servers: 3 for classic and 6 for Pro
- fixed a bug w/ auto-changing threads, set a limit to minimum 5 threads
- added sha256sum for spirit bins

## Spirit 1.25
- zap now keeps atime and mtime intact when cleaning logs
- fix issue w/ `./spirit forever` not being enabled for Pro license
- fix issue w/ `./spirit zap` not working on wtmp files
- fix free 1,000 external IP logic to stop script abuse
- `./spirit forever` now loads custom zone.lst file
- banner now filters out bad SSH versions
- banner max threads are capped at 2,500 to avoid skips
- fixed forever --append to work w/ arbitrary ports

## Spirit 1.24
- add `./spirit forever` command
- fix an issue on `./spirit masscan` where high ranges like US were crashing the app
- enable Pro license on ARM build

## Spirit 1.23
- fixed brute-key hanging on first successful attack
- improved hosts parsing, covering all edge cases
- improved banner accuracy
- added banner threads, timeout, hosts, output flags
- added rate limiting to license server (mitigate dos)

## Spirit 1.22
- moved scan from Pro to Classic
- moved brute-key to Pro
- Spirit includes 5 registered servers while Spirit Pro now includes 10 servers
- added './spirit reset' to delete your registered servers and start fresh

## Spirit 1.21.1
- improved helpfiles
- improved brute & banner speed
- improved automatic jobs calculations
- you can now brute faster than available hosts (removed limit)
- added 'Failed connections report' on brute
- Spirit is now free for Private IPs and up to 1,000 Public IPs without a license

## Spirit 1.21 adds a new tool to the Pro family:
> ./spirit scan --local all --threads 10000
- completely redesigned from the ground up TCP scanner
- understands wildcards '192.*.12-120.*'
- convenient local addresses preconfigured 10,172,192,all
- very accurate, tries a connection twice before reporting it dead
- we struck a balance between speed and accuracy
- doesn't require root privileges
- consult the helpfile ./spirit scan --help for more information
- as always this upgrade is available by simply doing ./spirit upgrade

## Spirit 1.20 adds a new tool to the Pro family:
> ./spirit bot -H HOST:PORT -c "#chan" --TLS=false
- To install: ./spirit bot -H HOST:PORT -c "#chan" --TLS=false --install
- defaults to channel #root if you provide no -c flag
- installs itself in systemd using the --install flag
- supports network encryption via SSL if your IRCd has SSL configured
- config is encrypted
- monitors files on your system like /etc/shadow, /root/authorized_keys, and more and gives you a NOTICE on IRC if anyone changes them, alerting you of possible intruders so you can keep your hosts safe.
- install works only for user root for now as it's Beta
- listens to commands using .c 'command' or botNick: c 'command'
- you can easily remove all bot traces w/ ./spirit bot --clean
- you must be able to set vhost to 'localhost' on your ircd for the bot to listen to you for added security

## all spirit versions for which I didn't publish changes
- bla bla
