# Spirit - Pentest Tools

Check out the helpfile [`$ ./spirit --help`](./HELP) to see the whole toolset.

## Example usage for SSH brute
```bash
# make sure your masscan command uses -oG open.lst for the results output file
$ masscan --rate="50000" --ports "22,222,2222,2212" 0.0.0.0/0 --exclude 255.255.255.255 -oG open.lst
Scanning 4294967295 hosts [4 ports/host]

$ ./spirit parse open.lst
INFO created h.lst in HOST:PORT format

$ ./spirit banner
SSH-2.0-OpenSSH_8.2p  13% [=>                  ] [11s:1m15s]
INFO created b.lst in HOST:PORT:BANNER format

$ mv b.lst h.lst

$ ./spirit brute
INFO loaded h.lst with 26803 hosts
INFO loaded p.lst with 4881 logins
[2478/4653]root:!1qwerty [77]found [33]blocked [1284]threads 20% [====>               ] [20s:1h13m36s]
$ less -S found.lst

Tip: you can automate these steps with `./spirit auto` or use the `./go.sh` script in `spirit.tgz`
```

## Download the latest Spirit release
- wget https://github.com/aogspirit/spirit/raw/master/spirit.tgz
- curl -OL https://github.com/aogspirit/spirit/raw/master/spirit.tgz

## Upgrade Spirit automaticaly
```bash
./spirit upgrade
Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```
>*Spirit can self-upgrade only on amd64 aka x86-64 for now. [`donate to speed things up`](#monero-xmr-thank-you)

>Try to `./spirit upgrade` daily, as we push new features and bug fixes very frequently.
> NOTE: If you need spirit for another CPU architecture like aarch64, mips, etc., just ask.

## Spirit is Free
For local IP addresses and up to 1,000 public IPs
We charge a small fee to help us support the project just for the Pro features, and if you need more than 1,000 Public IPs.

## Spirit Pro
Buy a Spirit Pro license directly from the CLI `./spirit buy`
Every license helps support our development and server costs.
Licensing information can be found running `./spirit pro --info`.

If you want to try a Pro feature, ask for a free Pro trial license.

## Referral
Show Spirit to your friends and earn 20% on your sales.

## Key Features
- brute multiple ports at once
- brute using private keys
- filter out honeypots
- block hosts that are unreachable, filter your IP, have fail2ban, and so forth (less dull work, faster completion)
- try every connection twice before blocking to increase accuracy
- set your optimal timeout and concurrent threads
- by using coroutines (lightweight threads), we reduce server load by (a lot :)
- performant and accurate banner grabber included
- connect to all your found hosts concurrently, upload files, execute commands at once
- automatically cleans connection logs (if uid0)
- and more... check out all the spirit tools! [`$ ./spirit --help`](./HELP)

# Support the Develpoment of the Spirit toolkit!
## Monero (XMR) thank you! (our favorite)
`8B81sxCMzoYc1cEu3EbHDfdCmtcooNtKp3sba9tGEpprM5PvADwXk76BFRRmuAUL2efvjm3Rp8uWHU5EULAPEbJGKoZ1x67`

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Get Help & Support
Open a Github [issue](https://github.com/theaog/spirit/issues)

Don't forget to give us a Star!

# Disclaimer

This tool should be used for authorized penetration testing and/or educational purposes only.
Any misuse of this software will not be the responsibility of the author or of any other collaborator.
Use it on your own systems and/or with the system owner's permission.

Usage of any tools in this repository for attacking targets without prior mutual consent is illegal.
It is the end user’s responsibility to obey all applicable local, state and federal laws.
We assume no liability and are not responsible for any misuse or damage caused.
