# Spirit - smart SSH brute toolkit
> Spirit tries 1 USER:PASS per HOST cycling through all the hosts and removing unreachable or filtered hosts. Each password attempt fewer hosts are being tried as the logic removes non-vulnerable hosts from the attack surface, this greatly increases the efficiency and speed of the brute-force attack.

We created this toolkit to speed up our offensive security pentesting tasks.
In Spirit you will find various tools beside the main SSH brute feature:
- brute (passfile)
- brute (private key)
- parse (parses masscan -oG output and creates h.lst containing IP:PORT)
- banner (grabs SSH banners without performing a login)
- auto (automatically run parse, banner, brute)
- scan (basic TCP network scan [unprivileged])
- abuse (checks your host against abuse databases)
- omni (connect to all vulnerable hosts at once)
- swarm (brute in distributed fashion [under development]) `donate to speed things up`

And more... check out the helpfile [`$ ./spirit --help`](./HELP)

## Example usage
```bash
# NB: Not a working masscan example
$ ./masscan --rate="5000" --ports "22,222,2222,2212" 0.0.0.0/0 -oG open.lst
Scanning 357886782 hosts [4 ports/host]

$ ./spirit parse open.lst
INFO created h.lst in HOST:PORT format

$ ./spirit --jobs 600 --timeout 1s banner
SSH-2.0-OpenSSH_8.2p  13% [=>                  ] (3686/26803) [11s:1m15s]
INFO created b.lst in HOST:PORT:BANNER format

$ mv b.lst h.lst
$ ./spirit --jobs 1500
INFO loaded h.lst with 26803 hosts
INFO loaded p.lst with 4881 logins
INFO estimated completion in ~1h27m36s
root:!1qwerty 192.168.0.1:22 found [77] blocked [33] 20% [====>               ] (1567/87216) [20s:1h13m36s]

You can automate these steps with ./spirit auto
```

## Download the latest Spirit release
- https://github.com/theaog/spirit/releases

## Self Upgrade
```bash
./spirit upgrade

Upgrading 87% [========================>     ] (5.9/5.9 MB, 49.652 MB/s)
```
>*Spirit can self-upgrade only on amd64 aka x86-64 for now. `donate to speed things up`

## Spirit Premium
Spirit has free tools inside
- banner grabber
- parse
- scan
- coin

The main features are although under Premium licensing to help support the development of the project.
Licensing information can be found running `./spirit premium --info`

You can buy a license directly from the CLI `./spirit premium --buy`

# Support the Develpoment of the Spirit tools!
## Monero (XMR) thank you!
`8B81sxCMzoYc1cEu3EbHDfdCmtcooNtKp3sba9tGEpprM5PvADwXk76BFRRmuAUL2efvjm3Rp8uWHU5EULAPEbJGKoZ1x67`

## Bitcoin (BTC) thank you too!
`bc1q7plm79dgllrhrjz772x4vjrtvu9yy03738psy5`

## Support
If you have any issues with Spirit, feel free to contact us directly on https://t.me/aogspirit or open a Github [issue](https://github.com/theaog/spirit/issues) or find us on #aog@OFTC.net
