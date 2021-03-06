# kali-setup
Initial setup of Kali for pentesting/bug hunting.

## What it does:
- Adds a non root user with sudo.
- Resets default kali user password.
- Runs: update and upgrade.
- Installs: 
  - VS Code: https://code.visualstudio.com/
  - seclists: https://github.com/danielmiessler/SecLists
  - gron: https://github.com/tomnomnom/gron
  - ripgrep: https://github.com/BurntSushi/ripgrep
  - gobuster: https://github.com/OJ/gobuster
  - ffuf: https://github.com/ffuf/ffuf
  - golang: https://golang.org/
  - RustScan: https://github.com/RustScan/RustScan
  - Joplin: https://joplinapp.org/
  - Google Chrome
- Sets up locate DB.

## Running
```bash
Usage:sudo ./setup.sh [OPTIONS] [ARGS]

Kali Setup Tool

OPTIONS: 
        -h                 Display this help message.
        -n <user>          Create a non root user with sudo access.
        -r                 Reset default kali user password.
        -i                 Update, Upgrade Install packages.
        -s                 Install and setup SSH Server.
```

To Do:
1. Add https://github.com/cddmp/enum4linux-ng
2. Add Joplin + Pentest Template
3. Useful aliases.
4. Possibly MobSF/Android Studio.
5. Add tool guide/tutorials.
   - tmux
   - gron
   - rigrep
   - gobuster
   - ffuf
   - rustscan
6. Add https://github.com/SecureAuthCorp/impacket stuff.
7. Add https://github.com/filedescriptor/untrusted-types.
   - untrusted-types video: https://www.youtube.com/watch?v=CNNCCgDkt5k
