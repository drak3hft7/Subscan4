# Subscan4
```bash
   _____       __                          __ __
  / ___/__  __/ /_  ______________ _____  / // /
  \__ \/ / / / __ \/ ___/ ___/ __  / __ \/ // /_
 ___/ / /_/ / /_/ (__  ) /__/ /_/ / / / /__  __/
/____/\__,_/_.___/____/\___/\__,_/_/ /_/  /_/-v1.0-drak3hft7
```

Last update: **05 Jan 2022**

This bash script is meant to be used during the Bug Bounty. It scans a specific domain, using the following tools:
- [Subfinder](https://github.com/projectdiscovery/subfinder/)
- [Assetfinder](https://github.com/tomnomnom/assetfinder)
- [Amass](https://github.com/OWASP/Amass)
- [Httpx](https://github.com/projectdiscovery/httpx/)

The script (with httpx) analyzes the subdomains found and checks the possible active web servers, on the ports: 
- 80, 8000, 8080, 443, 8443, 4443, 4433. 

Once the search is finished, the result is compared and saved in a single file called all_live_subdomains-DOMAIN.txt.

## Setup:
This setup script will install Go, Subfinder, Assetfinder, Amass and httpx on your vps.
```bash
cd /tmp && git clone https://github.com/drak3hft7/Subscan4 
sudo ./setup.sh
```

## Usage:
```bash
cd /tmp && git clone https://github.com/drak3hft7/Subscan4 
sudo ./Subscan4.sh -h
```
Use `--help` or `-h` to display the help menu.
