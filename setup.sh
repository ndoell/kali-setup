#!/bin/bash

#set -x

### Run this first.
# Check if running script with root privs.
userID=`id -u`
if [ "$userID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

usage () {
      echo "Usage: $0 [OPTIONS] [ARGS]"
      echo ""
      echo "Kali Setup Tool"
      echo ""
      echo "OPTIONS: "
      echo "        -h                 Display this help message."
      echo "        -n <user>          Create a non root user with sudo access."
      echo "        -r                 Reset default kali use password."
      echo "        -i                 Update, Upgrade Install packages."
      exit 0
}

adduser () {
  # Add User
  user=$1
  if [ -z "$user" ]
  then 
    echo "Please run this script with ./setup.sh <username>"
    echo "This will create a non root user with sudo access."
    #exit
  fi
  echo "Creating user: $user"
  useradd -m $user -s /bin/bash; passwd $user; usermod -a -G sudo $user
}

resetpw () {
    # Resetting default kali user password.
    echo "Resetting default kali user account password."
    passwd kali
}

letsgo () {
    # VSCode keys
    echo "Grabbing VSCode GPG key"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Update, Upgrade, Install seclists gron, gobuster, ffuf, golang, apt-transport-https and Clean
    echo "Running apt update, upgrade, install seclists, gron, ripgrep, gobuster, ffuf, golang, apt-transport-https and code. Ending with a clean and autoremove."
    apt-get update && \
    apt-get upgrade -y && \
    apt install -y seclists gron ripgrep gobuster ffuf golang apt-transport-https && \
    apt-get update && \
    apt install -y code && \
    apt-get clean && \
    apt-get autoremove

    # Install RustScan
    echo "Intalling RustScan. (Might change this to source and compile to get the latest and not worry about updating versions.)"
    RUSTSCANRLS="https://github.com/RustScan/RustScan/releases/download/2.0.1"
    RUSTSCANDEB="rustscan_2.0.1_amd64.deb"
    curl -LJO $RUSTSCANRLS/$RUSTSCANDEB
    dpkg -i $RUSTSCANDEB

    # Install Google Chrome
    echo "Installing current stable Google Chrome."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install ./google-chrome-stable_current_amd64.deb

    # Update locate
    updatedb
}

runit=false
while getopts ":hn:ri" opt; do
  case ${opt} in
    h )
      usage
      ;;
    n )
      user=$OPTARG
      adduser $user
      ;;
    r )
      resetpw
      ;;
    i )
      runit=true
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
