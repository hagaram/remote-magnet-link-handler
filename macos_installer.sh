#/usr/bin/env bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD='\033[1m' # Bold

command -v brew &>/dev/null
if [ $? -eq 1 ]; then
    echo "Please, install brew command, exiting..."
    exit 1
fi

read -p "Press enter to install duti and setup magnet link handler"

echo "\n${BOLD}Installing duti${NC}"
brew install duti

echo "\n\n"
echo "${BOLD}Specify installation path where you want scripts to be created, leave empty to use default (defaults to $HOME/software/qbitorrent_remote_magnet_handler):${NC}"
read install_path
install_path=${install_path:-"$HOME/software/qbitorrent_remote_magnet_handler"}


echo "\n${BOLD}Specify URL of your remote qBittorrent instance ${GREEN}(example: http(s)://192.168.1.200:8080)${NC}:"
read url

echo "\n${BOLD}Specify username and password, leave empty when using '${GREEN}Bypass from localhost/whitelisted IPs${NC}' ${BOLD}option${NC}:"
echo "${BOLD}Input username:${NC}"
read username
echo "${BOLD}Input password:${NC}"
read -s password


echo "\n${BOLD}Creating adder script in $install_path/adder.sh${NC}"

mkdir -p $install_path
cat <<EOF  > $install_path/adder.sh
#!$(which bash)

TORRENT=\$1
URL=$url
USER=$username
PASSWORD=$password
EOF

if [ ! -z "$username" ] && [ ! -z "$password" ] ; then
cat <<EOF >> $install_path/adder.sh
sid=\$(curl -s -i --header "Referer: \$URL" --data "username=\${USER}&password=\${PASSWORD}" \${URL}/api/v2/auth/login | sed -nE "s/.*(SID=.*); HttpOnly.*/\1/p")
curl --cookie "\$sid" --data "urls=\${TORRENT}" \${URL}/api/v2/torrents/add
curl \${URL}/logout --cookie "\$sid"
EOF
else
cat <<EOF >> $install_path/adder.sh
curl --data "urls=\${TORRENT}" \${URL}/api/v2/torrents/add
EOF
fi

chmod +x $install_path/adder.sh

echo "${BOLD}Creating Remote_magnet_handler.app and assigning association with magnet links${NC}"

echo "
on open location this_URL
	do shell script \"$install_path/adder.sh '\" & this_URL & \"'\"
end open location" > $install_path/remote_magnet_handler.scpt

osacompile -o /Applications/Remote_magnet_handler.app $install_path/remote_magnet_handler.scpt

perl -i -pe 's/(^\s+<key>LSMinimumSystemVersionByArchitecture<\/key>)/\t<key>CFBundleIdentifier<\/key>\n\t<string>com.apple.ScriptEditor.id.Remote-magnet-handler<\/string>\n$1/'  /Applications/Remote_magnet_handler.app/Contents/Info.plist
duti -s com.apple.ScriptEditor.id.Remote-magnet-handler magnet

echo "\n${GREEN}DONE${NC}"





