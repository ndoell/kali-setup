# kali-setup
Initial setup of Kali for pentesting/bug hunting.

## What it does:
- Adds a non root user with sudo.
- Runs: update and upgrade.
- Installs: 
  - VS Code
  - seclists
  - gron
  - gobuster
  - ffuf
  - golang
  - RustScan
  - Google Chrome
- Sets up locate DB.

## Running
```bash
sudo ./setup.sh <username>
```