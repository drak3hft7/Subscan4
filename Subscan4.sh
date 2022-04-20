#!/bin/bash -i
# Author: drak3hft7
# Date: 05/01/2022

outputDir=$PWD

#---------------------------------------------- Colors used in the script
green='\e[32m'
blue='\e[34m'
lightblue='\e[36m'
orange='\e[93m'
red='\e[91m'
white='\e[97m'

#---------------------------------------------- Check if the script is executed with root privileges
if [ "${UID}" -eq 0 ]
then
    echo "";
else
    echo ""; echo -e "$red[Attention]Root privileges are required. $white";
    exit
fi

#---------------------------------------------- Header
echo -e "$blue
   _____       __                          __ __
  / ___/__  __/ /_  ______________ _____  / // /
  \__ \/ / / / __ \/ ___/ ___/ __  / __ \/ // /_
 ___/ / /_/ / /_/ (__  ) /__/ /_/ / / / /__  __/
/____/\__,_/_.___/____/\___/\__,_/_/ /_/  /_/-v1.0-drak3hft7"

echo " "

#---------------------------------------------- Help and Options
for arg in "$@"
do
    case $arg in
        -h|--help)
        echo -e "$lightblue 
Subscan4 - This script uses the following 4 tools (Sublister, Amass, Assetfinder, Httpx) to enumerate the target subdomains."
        echo " "
        echo "$0 [options]"
        echo " "
        echo "Options:"
        echo "        -h, --help                         show brief help"
        echo "        -d, --domain <domain>              domain to scan. Example: domain.com"
        echo "        -o, --output <dir>   		 directory to save the results. Example: /output"
        echo " "
        echo "Example:"
        echo "        $0 -d domain.com -o /domain-com"
        echo -e "$white";
        exit 0
        ;;
        -d|--domain)
        domain+=("$2")
        shift
        ;;
        -o|--output)
        inputdirectory+="$3"
        shift
    esac
done

#---------------------------------------------- User definition of the target domain is essential.
if [ "${#domain[@]}" -ne 0 ]
then
    IFS=', ' read -r -a DOMAINS <<< "${domain[@]}"
else
    read -r -p "You have not entered any target. You can enter it now. Example: domain.com -----> Domain: " inputdomain
    IFS=', ' read -r -a DOMAINS <<< "$inputdomain"  
fi
#---------------------------------------------- Define where to save the generated files.
if [ "${#inputdirectory[@]}" -ne 0 ]
then
    IFS=', ' read -r -a DIRECTORY <<< "${inputdirectory[@]}"
else
    read -r -p "You have not entered any directory for save your output. You can enter it now. Example: /domain-com -----> Directory: " inputdirectory
    IFS=', ' read -r -a DIRECTORY <<< "$inputdirectory"  
fi
if [ ! -d "$inputdirectory" ]
then
    read -r -N 1 -p "Provided output directory \"$outputDir$inputdirectory\" does not exist, create it? [Y/N] "
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo -e "$white";
        exit 1
    fi
    mkdir -p "$outputDir$inputdirectory"
fi
#---------------------------------------------- Start Subdomains scan.
echo -e "";
echo -e "$blue[OK] Starting Subdomains scan"
echo -e "";
for DOMAIN in "${DOMAINS[@]}"
do

    cd /root/go/bin

    echo -e "$orange[Subfinder] in progress...";
    subfinder -d "$DOMAIN" -all -o $outputDir$inputdirectory/subfinder-$DOMAIN.txt -v > /dev/null 2>&1;
    if [ ! -f "live-subfinder-httpx-$DOMAIN.txt" ] || [ "$overwrite" = true ]
    then
        echo -e "$orange[Httpx] in progress with the results Subfinder...";
        httpx -silent -no-color -l "$outputDir$inputdirectory/subfinder-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 -threads 25 -o "$outputDir$inputdirectory/subfinder-httpx-$DOMAIN.txt" > /dev/null 2>&1;
        cut -d' ' -f1 < "$outputDir$inputdirectory/subfinder-httpx-$DOMAIN.txt" | sort -u > "$outputDir$inputdirectory/live-subfinder-httpx-$DOMAIN.txt"
    fi
    	echo -e "$blue[OK Subfinder] scan performed.";
    	echo -e "";
    	echo -e "$orange[Assetfinder] in progress...";
    assetfinder -subs-only "$DOMAIN" | tee $outputDir$inputdirectory/assetfinder-$DOMAIN.txt > /dev/null 2>&1;
    if [ ! -f "live-assetfinder-httpx-$DOMAIN.txt" ] || [ "$overwrite" = true ]
    then
        echo -e "$orange[Httpx] in progress with the results Assetfinder...";
        httpx -silent -no-color -l "$outputDir$inputdirectory/assetfinder-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 -threads 25 -o "$outputDir$inputdirectory/assetfinder-httpx-$DOMAIN.txt" > /dev/null 2>&1;
        cut -d' ' -f1 < "$outputDir$inputdirectory/assetfinder-httpx-$DOMAIN.txt" | sort -u > "$outputDir$inputdirectory/live-assetfinder-httpx-$DOMAIN.txt"
    fi
    	echo -e "$blue[OK Assetfinder] scan performed.";
    	echo -e "";
    	echo -e "$orange[Amass] in progress...";
    amass enum --passive -d  "$DOMAIN" -o $outputDir$inputdirectory/amass-$DOMAIN.txt > /dev/null 2>&1;
    if [ ! -f "live-amass-httpx-$DOMAIN.txt" ] || [ "$overwrite" = true ]
    then
        echo -e "$orange[Httpx] in progress with the results Amass...";
        httpx -silent -no-color -l "$outputDir$inputdirectory/amass-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 -threads 25 -o "$outputDir$inputdirectory/amass-httpx-$DOMAIN.txt" > /dev/null 2>&1;
        cut -d' ' -f1 < "$outputDir$inputdirectory/amass-httpx-$DOMAIN.txt" | sort -u > "$outputDir$inputdirectory/live-amass-httpx-$DOMAIN.txt"
    fi
    	echo -e "$blue[OK Amass] scan performed."
    	echo -e "";
    	
#---------------------------------------------- Merges subdomains into one file, eliminating duplicate ones.
    echo -e "$blue[OK] Master file creation subdomains."
    sleep 1.5
    cat $outputDir$inputdirectory/live-*.txt >> $outputDir$inputdirectory/master_live_subdomains-$DOMAIN.txt; sort $outputDir$inputdirectory/master_live_subdomains-$DOMAIN.txt | uniq > $outputDir$inputdirectory/all_live_subdomains-$DOMAIN.txt    	
    	 	
done
echo -e "";
echo -e "$red\e[1m[OK] DONE!\e[0m $white"
echo -e "";
