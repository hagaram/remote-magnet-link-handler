#/usr/bin/env bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD='\033[1m' # Bold

command -v brew &>/dev/null
if [ $? -eq 1 ]; then
    echo "Please, install brew command, exiting..."
    exit 1
fi
command -v pip3 &>/dev/null
if [ $? -eq 1 ]; then
    echo "Please, install pip3 command, exiting..."
    exit 1
fi

read -p "Press enter to install python-qbittorent, duti and setup magnet link handler"

echo "\n${BOLD}Installing python-qbittorrent library${NC}"
pip3 install python-qbittorrent
echo "\n${BOLD}Installing duti${NC}"
brew install duti


echo "\n\n"
echo "${BOLD}Specify installation path where you want scripts to be created, leave empty to use default (defaults to $HOME/qbitorrent_remote_magnet_handler):${NC}"
read install_path
install_path=${install_path:-"$HOME/qbitorrent_remote_magnet_handler"}


echo "\n${BOLD}Specify URL of your remote qBittorrent instance ${GREEN}(example: http(s)://192.168.1.200:8080)${NC}:"
read url

echo "\n${BOLD}Specify username and password, leave empty when using '${GREEN}Bypass from localhost${NC}' ${BOLD}option${NC}:"
echo "${BOLD}Input username:${NC}"
read username
echo "${BOLD}Input password:${NC}"
read -s password


echo "\n${BOLD}Creating adder script in $install_path/adder.py${NC}"

mkdir -p $install_path
echo "#!$(which python3)

import sys
from qbittorrent import Client

qb = Client('$url')" > $install_path/adder.py

if [ ! -z "$username" ] && [ ! -z "$password" ] ; then 
  echo "qb.login('$username', '$password')" >> $install_path/adder.py
fi

echo "
magnet_link = sys.argv[1]
qb.download_from_link(magnet_link)" >> $install_path/adder.py

chmod +x $install_path/adder.py

echo "${BOLD}Creating Remote_magnet_handler.app and assigning association with magnet links${NC}"

echo "
on open location this_URL
	do shell script \"$install_path/adder.py '\" & this_URL & \"'\"
end open location" > $install_path/remote_magnet_handler.scpt

osacompile -o /Applications/Remote_magnet_handler.app $install_path/remote_magnet_handler.scpt

perl -i -pe 's/(^\s+<key>LSMinimumSystemVersionByArchitecture<\/key>)/\t<key>CFBundleIdentifier<\/key>\n\t<string>com.apple.ScriptEditor.id.Remote-magnet-handler<\/string>\n$1/'  /Applications/Remote_magnet_handler.app/Contents/Info.plist
duti -s com.apple.ScriptEditor.id.Remote-magnet-handler magnet


echo "\n${GREEN}DONE${NC}"

