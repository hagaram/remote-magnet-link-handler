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

## Torrent client compatibility:
- qbittorrent (tested on v.4.1.9.1
- transmission (tested on v.3.0.0)

## Tested on:
- MacOS Catalina (didn't try any other MacOS version)
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