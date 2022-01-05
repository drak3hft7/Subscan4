#!/bin/bash -i
# Author: drak3hft7
# Date: 05/01/2022

# Check if the script is executed with root privileges
if [ "${UID}" -eq 0 ]
then
    echo ""; echo -e "\e[32m\e[1mOK. The script will install the tools.\e[0m\e[39m"; echo "";
else
    echo ""; echo -e "\e[91m\e[1mRoot privileges are required\e[0m\e[39m"; echo "";
    exit
fi

#---------Install Golang
echo -e "\e[93m\e[1m----> Golang environment installation in progress ...";
cd /tmp && curl -O https://dl.google.com/go/go1.17.linux-amd64.tar.gz > /dev/null 2>&1 && tar xvf go1.17.linux-amd64.tar.gz > /dev/null 2>&1;
mv go /usr/local
export GOROOT=/usr/local/go && export GOPATH=$HOME/go && export PATH=$GOPATH/bin:$GOROOT/bin:$PATH;
echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile && echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile	&& echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile;
source ~/.bash_profile
echo -e "\e[32mGolang environment installation is done !"; echo "";
sleep 1.5
#---------Install Subfinder
echo -e "\e[93m\e[1m----> Installing Subfinder";
go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder > /dev/null 2>&1 && ln -s ~/go/bin/subfinder /usr/local/bin/;
echo -e "\e[32mDone! Subfinder installed."; echo "";
sleep 1.5
#---------Install Assetfinder
echo -e "\e[93m\e[1m----> Installing Assentfinder";
go get -u github.com/tomnomnom/assetfinder > /dev/null 2>&1 && ln -s ~/go/bin/assetfinder /usr/local/bin/;
echo -e "\e[32mDone! Assetfinder installed."; echo "";
sleep 1.5
#---------Install Amass
echo -e "\e[93m\e[1m----> Installing Amass";
go get -v github.com/OWASP/Amass/v3/... > /dev/null 2>&1 && ln -s ~/go/bin/amass /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Amass installed."; echo "";
sleep 1.5
#---------Install httpx
echo -e "\e[93m\e[1m----> Installing httpx";
go get -v github.com/projectdiscovery/httpx/cmd/httpx > /dev/null 2>&1 && ln -s ~/go/bin/httpx /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Httpx installed."; echo "";
sleep 1.5

echo -e "\e[92mDone! Operation complete.\e[0m\e[39m"; echo "";