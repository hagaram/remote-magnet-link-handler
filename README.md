## Motivation:

I wanted to be able to add magnet links to my remote qbittorrent instance on click and browser plugins just didn't work in my case.
This is my "one evening" take on this issue.

**FEEL FREE TO MAKE IT BETTER, I WILL BE GLAD IF THIS WILL BE OF ANY USE TO SOMEONE OTHER THAN ME.**

## Requirements:
### MacOS
  - brew installed

## Torrent client compatibility:
- qbittorrent

## OS compatibility:
- MacOS Catalina (didn't try any other MacOS version)


## How to:
run:
`chmod +x ./macos_installer.sh && ./macos_installer.sh`
and follow the steps.


## Caveats:
### MacOS
  - installs duti command


## TODO (which I might or might not do):
- create "installer" for Linux
- add more tests and error handling, as the script is quite straightforward
- make it work with more torrent clients