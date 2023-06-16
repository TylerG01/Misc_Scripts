# Misc_Scripts
Repository for miscilaneous Bash &amp; Python Scripts
## Intro
This is a repository of unassorted Bash/Shell and Python scripts which have been developed to automate various repetitive tasks in my research. This repository will grow over time, as I both prune identifying information from my existing scripts and as new scripts are either created or discovered (on other repos’) – all of which I hope help others in their early to mid-level bash and python education. 

### UbuntuVM Setup.sh
At the time of the writing, I’m using Pop!_OS as my daily driver and like many of you, I use virtual machines for much of my development and testing environments. This script was built to automate the following: 
- Detects OS type, then removes known telemetry if the OS is Ubuntu.
- Installs VSCodium, Docker, Docker-Compose as well as a series of network tools
- Installs Tor tools, such as Tor Browser, Onionshare and Tor Proxychians
- Configures both vulscan(within nmap) as well as Proxychains in accordance with best practices
–	Checks for errors in all public keyring pgp signatures, then prints errors to .txt file.

**Disclaimer**: This script assumes 4 CPU cores have been allocated to your VM, as seen with the use of the parallel function (‘&, wait’) between lines 36 & 46. If you are using fewer cores, please modify this accordingly. 
