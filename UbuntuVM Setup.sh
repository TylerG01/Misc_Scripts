#!/bin/bash

# Ubuntu, Mint, Pop!_OS script for VM dev environment
# Work in progress 

osdet=$(uname -n)
if [[ $osdet == *"ubuntu"* ]]; then
  sudo apt remove -y apport
  sudo apt remove -y popularity-contest
else
  echo "No modification needed"
fi

# First update/upgrade
sudo apt update && sudo apt upgrade -y


# Build Directories
mkdir ~/Downloads/Programs/Tor
mkdir ~/Documents/Logs


# Installing VSCodium: https://vscodium.com/#install
# Add the GPG key of the repository:
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
# Add the repository:
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
# Update then install vscodium 
sudo apt update && sudo apt install codium


# Installing Docker & Docker Compose
sudo apt install docker.io docker-compose -y


# Network Tools
# Installing nmap
sudo apt install nmap -y &
# Installing ipcalc
sudo apt install ipcalc -y &
# Install wireshark
sudo apt install wireshark -y &
# Clone masscan
sudo apt install masscan 
wait 
sudo apt update


# Adding/Configuring vulcan to nmap 
cd /usr/share/nmap/scripts
mkdir vulscan
cd vulscan
sudo git clone https://github.com/scipag/vulscan scipag_vulscan
ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan    
cd scipag_vulscan
sudo chmod 744 update.sh
./update.sh
cd -e


# Metedata Tools
# Installing mat2 (metadata removal)
sudo apt install mat2 -y &
# Installing Exif Tool
sudo apt install exiftool -y 
wait


# Installing Tor Tools
cd ~/Downloads/Programs/Tor
sudo apt install tor -y
sudo apt install torbrowser-launcher -y
#Fetrching Tor Developers key
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
# Save to keyring
gpg --output ./tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
# Verfiying Signature
gpgv --keyring ./tor.keyring ~/Downloads/tor-browser-linux64-9.0_en-US.tar.xz.asc ~/Downloads/tor-browser-linux64-9.0_en-US.tar.xz
sudo apt update
# Installing OnionShare
sudo apt install onionshare -y
# Download PGP signature file
wget https://keys.openpgp.org/vks/v1/by-fingerprint/927F419D7EC82C2F149C1BD1403C2657CD994F73
# Download public Key
wget https://onionshare.org/dist/2.2/OnionShare-2.2.pkg.asc
# Import Key into public keyring
gpg --import OnionShare-2.2.pkg.asc
# Install Tor Proxychains
sudo apt-get install proxychains -y


# Configuring Proxychains
# Commands listed in order of appearance in proxychains.conf file. 
cd /etc
# Uncomment Dynamic chain
sudo sed -i 's/#dynamic_chain/dynamic_chain/g' proxychains.conf
# Comment Strict Chain
sudo sed -i 's/strict_chain/#strict_chain/g' proxychains.conf
# Comment Random Chain
sudo sed -i 's/random_chain/#random_chain/g' proxychains.conf
# Uncomment Proxy DNS Comment 
sudo sed -i 's/#proxy_dns/proxy_dns/g' proxychains.conf
# Write 'socks5 127.0.0.1 9050' after 64rd line
sudo sed -i '65 a socks5 127.0.0.1 9050' proxychains.conf
# Restarting Tor to save configuration
cd -e
sudo service tor restart


# check for errors in all public keyring pgp signatures, then print to .txt file.
# Set the output file
pgp_error_log="pgp_signature_errors.txt"
# Check for errors in all public keyring pgp signatures
gpg --list-sigs --check-sigs > $pgp_error_log
# Print the results to the output file
echo "Errors in public keyring pgp signatures:" >> $pgp_error_log
gpg --list-sigs --check-sigs | grep -i "error" >> $pgp_error_log
# Print a success message
echo "Finished checking for errors in public keyring pgp signatures. Results printed to $pgp_error_log"
# Move log file
mv pgp_signature_errors.txt ~/Documents/Logs

exit
