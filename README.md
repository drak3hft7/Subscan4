# Subscan4
```bash
   _____       __                          __ __
  / ___/__  __/ /_  ______________ _____  / // /
  \__ \/ / / / __ \/ ___/ ___/ __  / __ \/ // /_
 ___/ / /_/ / /_/ (__  ) /__/ /_/ / / / /__  __/
/____/\__,_/_.___/____/\___/\__,_/_/ /_/  /_/-v1.0-drak3hft7
```

Last update: **05 Jan 2022**

Script that performs a scan of a specific domain, using the following tools: 
- [Subfinder](https://github.com/projectdiscovery/subfinder/)
- [Assetfinder](https://github.com/tomnomnom/assetfinder)
- [Amass](https://github.com/OWASP/Amass)
- [Httpx](https://github.com/projectdiscovery/httpx/)

The script (with httpx) analyzes the subdomains found and checks the possible active web servers, on the ports: 
- 80, 8000, 8080, 443, 8443, 4443, 4433. 

Once the search is finished, the result is compared and saved in a single file called all_live_subdomains-DOMAIN.txt.
