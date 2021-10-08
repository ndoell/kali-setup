#!/bin/bash

#set -x

export DEBIAN_FRONTEND=noninteractive

COLOR_RED=`tput setaf 1`
COLOR_GREEN=`tput setaf 2`
COLOR_YELLOW=`tput setaf 3`
COLOR_BLUE=`tput setaf 4`
COLOR_RESET=`tput sgr0`
SILENT=false

print() {
    if [[ "${SILENT}" == false ]] ; then
        echo -e "$@"
    fi
}

### Run this first.
# Check if running script with root privs.
userID=`id -u`
if [ "$userID" -ne 0 ]
  then 
  print "${COLOR_RED}"
  print "Please run as root"
  print "${COLOR_RESET}"
  exit 1
fi

# Create a directory for any artifacts.
if [ -d "work/" ] 
then
    # Remove Dir if it exist.
    print "${COLOR_GREEN}"
    print "Found work directory, removing it."
    rm -rf work 
    print "${COLOR_RESET}"
else
    print "${COLOR_GREEN}"
    print "Creating work directory in the current path."
    mkdir -p work/
    cd work
    print "${COLOR_RESET}"
fi


usage () {
      print "${COLOR_BLUE}"
      print "Usage: $0 [OPTIONS] [ARGS]"
      print ""
      print "Kali Setup Tool"
      print ""
      print "OPTIONS: "
      print "        -h                 Display this help message."
      print "        -n <user>          Create a non root user with sudo access."
      print "        -r                 Reset default kali user password."
      print "        -i                 Update, Upgrade Install packages."
      print "        -s                 Install and setup SSH Server."
      print "${COLOR_RESET}"
}

adduser () {
  # Add User
  USER=$1

  # Check if the user already exist.
  getent passwd $USER  > /dev/null
  if [ $? -eq 0 ]; then
    print "${COLOR_RED}"
    print "The user: ${USER} already exist"
    print "${COLOR_RESET}"
  else
    print "${COLOR_GREEN}"
    print "Creating user: $user"
    print "${COLOR_RESET}"
    useradd -m $USER -s /bin/bash; passwd $user; usermod -a -G sudo $user
  fi
}

resetpw () {
    # Resetting default kali user password.
    print "${COLOR_GREEN}"
    print "Resetting default kali user account password."
    print "${COLOR_RESET}"
    passwd kali
}

letsgo () {

    # VSCode keys
    print "${COLOR_GREEN}"
    print "Grabbing VSCode GPG key"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Install RustScan
    print "Intalling RustScan. (Might change this to source and compile to get the latest and not worry about updating versions.)"
    RUSTSCANRLS="https://github.com/RustScan/RustScan/releases/download/2.0.1"
    RUSTSCANDEB="rustscan_2.0.1_amd64.deb"
    curl -LJO $RUSTSCANRLS/$RUSTSCANDEB
    dpkg -i $RUSTSCANDEB

    # Install Google Chrome
    pirnt "Installing current stable Google Chrome."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install -y ./google-chrome-stable_current_amd64.deb

    # Update, Upgrade, Install seclists gron, gobuster, ffuf, golang, apt-transport-https and Clean
    print "Running apt update, upgrade, installing ${PACKAGES} and code. Ending with a clean and autoremove."
    apt-get update && \
    apt-get upgrade -y && \
    cat ../packages.txt | xargs apt-get install -y && \
    apt-get update && \
    apt-get install -y code && \
    apt-get clean && \
    apt-get autoremove

    # Update locate
    print "Updating locate"
    updatedb
    print "You should probably `sudo reboot`"
    print "${COLOR_RESET}"

}

setupssh () {
  print "${COLOR_GREEN}"
  print "Install openssh-server just incase you don't have it."
  apt-get install openssh-server

  print "Backup default keys"
  mkdir /etc/ssh/default_keys
  mv /etc/ssh/ssh_host_* /etc/ssh/default_keys/

  print "Generate new keys."
  dpkg-reconfigure openssh-server

  print "Further configure SSH here: /etc/ssh/sshd_config."

  print "Starting SSH Service"
  service ssh start

  print "Enabling SSH service after reboots."
  systemctl enable ssh.service

  print ""
  print ""
  print "Print current SSH Status"
  service ssh status
  print "${COLOR_RESET}"

}

runit=false
while getopts ":hn:ris" opt; do
  case ${opt} in
    h )
      usage
      ;;
    n )
      USER=$OPTARG
      adduser $USER
      ;;
    r )
      resetpw
      ;;
    i )
      runit=true
      ;;
    s )
      setupssh
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      usage
      exit 1
      ;;
    : )
      echo "Invalid Option: -$OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Run install function outside of getopts loop.
if [ "$runit" = true ];
then    
    # Get all the good stuff.
    letsgo
fi
print "${COLOR_GREEN}"
print "Clean up work directory"
print "${COLOR_RESET}"
cd ..; rm -rf work
