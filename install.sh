#!/usr/bin/env bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD='\033[1m' # Bold
PLATFORM=$(uname)
APP_NAME="Remote_magnet_handler"
COMPATIBLE_CLIENTS="qbittorrent transmission"


####FC START


macos_check_reqs () {
  command -v brew &>/dev/null
  if [ $? -eq 1 ]; then
      printf "Please, install brew command and re-run the script, exiting...\n"
      exit 1
  fi
  command -v duti &>/dev/null
  if [ $? -eq 1 ]; then
    printf "\n${BOLD}Installing duti${NC}\n"
    brew install duti
  fi
}

linux_check_reqs() {
  command -v curl &>/dev/null
  if [ $? -eq 1 ]; then
    distro=$(sed -nr  "s/^ID=\"?([a-zA-Z]+)\"?/\1/p" /etc/os-release)
    printf "\n${BOLD}Installing curl${NC}\n"
    case $distro in
      arch)
        sudo pacman -Sy curl
        ;;
      centos | rhel | fedora)
        sudo dnf -y install curl
        ;;
      debian | ubuntu)
        sudo apt-get update
        sudo apt-get -y install curl
        ;;
      *)
        printf "Unknown distro, install curl manually and re-run the script, exiting...\n"
        exit 0;
        ;;
    esac
  fi
}


create_linux_middleware_app () {
  printf "${BOLD}Creating ${APP_NAME}.desktop entry${NC}\n"
  mkdir -p $HOME/.local/share/applications/
  cat <<EOF > ${HOME}/.local/share/applications/${APP_NAME}.desktop
[Desktop Entry]
Name=${APP_NAME}
Type=Application
Exec=${install_path}/adder.sh %u
NoDisplay=true
MimeType=x-scheme-handler/magnet;
Terminal=false
EOF
}


configure_linux_magnet_association () {
  printf "${BOLD}Assigning association with magnet links${NC}\n"
  xdg-mime default ${APP_NAME}.desktop x-scheme-handler/magnet
}


create_macos_middleware_app () {
  printf "${BOLD}Creating ${APP_NAME}.app${NC}"
  cat <<EOF > ${install_path}/${APP_NAME}.scpt
on open location this_URL
	do shell script "${install_path}/adder.sh '" & this_URL & "'"
end open location
EOF

  osacompile -o /Applications/${APP_NAME}.app ${install_path}/${APP_NAME}.scpt
  perl -i -pe 's/(^\s+<key>LSMinimumSystemVersionByArchitecture<\/key>)/\t<key>CFBundleIdentifier<\/key>\n\t<string>com.apple.ScriptEditor.id.Remote-magnet-handler<\/string>\n$1/'  /Applications/${APP_NAME}.app/Contents/Info.plist
}


configure_macos_magnet_association () {
  printf "\n${BOLD}Assigning association with magnet links${NC}"
  duti -s com.apple.ScriptEditor.id.Remote-magnet-handler magnet
}

configure_torrent_client () {

  export PS3="Choose number: "
  printf "${BOLD}Pick torrent client you want to use${NC}:\n"
  select client in ${COMPATIBLE_CLIENTS}
  do
    break
  done

  printf "\n\n${BOLD}Specify installation path where you want scripts to be created, leave empty to use default ${GREEN}(defaults to $HOME/software/${APP_NAME})${NC}:\n"
  read install_path
  install_path=${install_path:-"$HOME/software/$APP_NAME"}

  printf "\n${BOLD}Specify URL of your remote qBittorrent instance ${GREEN}(example: http(s)://192.168.1.200:8080)${NC}:\n"
  read url

  printf "\n${BOLD}Specify username and password, leave both empty when using '${GREEN}Bypass from whitelisted IPs/Auth disabled${NC}' ${BOLD}options${NC}:\n"
  printf "${BOLD}Input username:${NC}\n"
  read username
  printf "${BOLD}Input password:${NC}\n"
  read -s password

  printf "\n${BOLD}Creating adder script in ${install_path}/adder.sh${NC}\n"

  mkdir -p ${install_path}
  cat <<EOF  > ${install_path}/adder.sh
#!$(which bash)

TORRENT=\$1
URL=$url
USER=$username
PASSWORD=$password
EOF


  source templates/${client}.template
  chmod +x ${install_path}/adder.sh


}
####FC END


main () {
  case $PLATFORM in
    Darwin)
      macos_check_reqs
      ;;
    Linux)
      linux_check_reqs
  esac
  
  configure_torrent_client
  
  case $PLATFORM in
    Darwin)
      create_macos_middleware_app
      configure_macos_magnet_association
      ;;
    Linux)
      create_linux_middleware_app
      configure_linux_magnet_association
      ;;
  esac
  
  printf "\n${GREEN}DONE${NC}\n"
}

main
