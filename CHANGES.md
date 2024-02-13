## Spirit 1.30
- NEW: proxy-banner: faster, more accurate and handsome -- with Terminal UI
- NEW: encrypt: make an AES256/GCM encrypted version of your p.lst passfile
- updated flags for `scan`
- added license reset limits
- secured input for license key during register and reset
- added proxy.lst SOCKS5:IP:PORT for ultra-banner
- added spirit arm64 and i386 versions
- add bot command: an fast irc bot written from scratch
- changed omni to omni-ssh
- added threads/timeout to omni
- reduced servers per license and reduced prices:
  - Basic 1 $29 / Pro 3 $99 / Ultra 9 $299

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
