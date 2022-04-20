# Subscan4
```bash
   _____       __                          __ __
  / ___/__  __/ /_  ______________ _____  / // /
  \__ \/ / / / __ \/ ___/ ___/ __  / __ \/ // /_
 ___/ / /_/ / /_/ (__  ) /__/ /_/ / / / /__  __/
/____/\__,_/_.___/____/\___/\__,_/_/ /_/  /_/-v1.0-drak3hft7
```

Last update: **20 Apr 2022**

This bash script is meant to be used during the Bug Bounty. It scans a specific domain, using the following tools:
- [Subfinder](https://github.com/projectdiscovery/subfinder/)
- [Assetfinder](https://github.com/tomnomnom/assetfinder)
- [Amass](https://github.com/OWASP/Amass)
- [Httpx](https://github.com/projectdiscovery/httpx/)

The script (with httpx) analyzes the subdomains found and checks the possible active web servers, on the ports: 
- 80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 

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
- `--help` or `-h` to display the help menu.
- `--domain` or `-d` to set up the domain.
- `--output` or `-o` to set the directory.

![Screen_Subscan02](Images/Screen_Subscan02.PNG 'Example')

### Example:
```bash
./Subscan4.sh -d domain.com -o /domain
```

![Screen_Subscan](Images/Screen_Subscan.PNG 'Example1')
