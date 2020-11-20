#!/bin/bash

#set -x

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
  then echo "Please run as root"
  exit
fi

# Create a directory for any artifacts.
if [ -d "work/" ] 
then
    # Remove Dir
    rm -rf work 
else
    mkdir -p work/
    cd work
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
      print "${COLOR_RESET}"
}

adduser () {
  # Add User
  user=$1

  # Check if the user already exist.
  getent passwd $user  > /dev/null
  if [ $? -eq 0 ]; then
    echo "This user already exist"
  else
    echo "Creating user: $user"
    useradd -m $user -s /bin/bash; passwd $user; usermod -a -G sudo $user
  fi
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

    # Update, Upgrade, Install seclists gron, gobuster, ffuf, golang, apt-transport-https and Clean
    echo "Running apt update, upgrade, installing ${PACKAGES} and code. Ending with a clean and autoremove."
    apt-get update && \
    apt-get upgrade -y && \
    cat ../packages.txt | xargs apt-get install -y && \
    apt-get update && \
    apt-get install -y code && \
    apt-get clean && \
    apt-get autoremove

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

# Clean up work directory
cd ..; rm -rf work