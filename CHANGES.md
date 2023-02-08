## Spirit 1.24
- add `./spirit forever` command
- fix an issue on `./spirit masscan` where high ranges like US were crashing the app
- enable Pro license on ARM build
- zap now keeps atime and mtime intact when cleaning logs

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
