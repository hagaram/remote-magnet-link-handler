## Motivation:

I wanted to be able to add magnet links to my remote qbittorrent instance on click and browser plugins just didn't work in my case.
This is my take on this issue.

**FEEL FREE TO MAKE IT BETTER, I WILL BE GLAD IF THIS WILL BE OF ANY USE TO SOMEONE OTHER THAN ME.**

## Requirements:
### MacOS
  - brew installed beforehand

## Caveats:
### MacOS
  - installs duti if not present
### Linux
  - installs curl if not present
### Deluge
  - expects deluge-web to be connected to deluged service, script doesn't handle this part when adding torrents

## Torrent client compatibility:
- qbittorrent (tested on v.4.1.9.1
- transmission (tested on v.3.0.0)
- deluge (tested on 1.3.5 --> Without auth bypass, as it is not officialy supported)

## Tested on:
- MacOS Catalina
- MacOS BigSur
- Arch with KDE
- Debian 10 with XFCE ( should work on other distros and DEs)


## How to:
clone repository, run:
`chmod +x ./installer.sh && ./installer.sh`
and follow the steps.


## TODO (which I might or might not do):
- add more tests and error handling, as the script is quite straightforward
- make it work with more torrent clients


## Credits
Transmissions CURL was inspired by https://gist.github.com/sbisbee/8215353
