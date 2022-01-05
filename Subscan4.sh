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
        httpx -silent -no-color -l "$outputDir$inputdirectory/subfinder-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,8000,8080,443,8443,4443,4433 -threads 25 -o "$outputDir$inputdirectory/subfinder-httpx-$DOMAIN.txt" > /dev/null 2>&1;
        cut -d' ' -f1 < "$outputDir$inputdirectory/subfinder-httpx-$DOMAIN.txt" | sort -u > "$outputDir$inputdirectory/live-subfinder-httpx-$DOMAIN.txt"
    fi
    	echo -e "$blue[OK Subfinder] scan performed.";
    	echo -e "";
    	echo -e "$orange[Assetfinder] in progress...";
    assetfinder -subs-only "$DOMAIN" | tee $outputDir$inputdirectory/assetfinder-$DOMAIN.txt > /dev/null 2>&1;
    if [ ! -f "live-assetfinder-httpx-$DOMAIN.txt" ] || [ "$overwrite" = true ]
    then
        echo -e "$orange[Httpx] in progress with the results Assetfinder...";
        httpx -silent -no-color -l "$outputDir$inputdirectory/assetfinder-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,8000,8080,443,8443,4443,4433 -threads 25 -o "$outputDir$inputdirectory/assetfinder-httpx-$DOMAIN.txt" > /dev/null 2>&1;
        cut -d' ' -f1 < "$outputDir$inputdirectory/assetfinder-httpx-$DOMAIN.txt" | sort -u > "$outputDir$inputdirectory/live-assetfinder-httpx-$DOMAIN.txt"
    fi
    	echo -e "$blue[OK Assetfinder] scan performed.";
    	echo -e "";
    	echo -e "$orange[Amass] in progress...";
    amass enum --passive -d  "$DOMAIN" -o $outputDir$inputdirectory/amass-$DOMAIN.txt > /dev/null 2>&1;
    if [ ! -f "live-amass-httpx-$DOMAIN.txt" ] || [ "$overwrite" = true ]
    then
        echo -e "$orange[Httpx] in progress with the results Amass...";
        httpx -silent -no-color -l "$outputDir$inputdirectory/amass-$DOMAIN.txt" -title -tech-detect -content-length -web-server -status-code -ports 80,8000,8080,443,8443,4443,4433 -threads 25 -o "$outputDir$inputdirectory/amass-httpx-$DOMAIN.txt" > /dev/null 2>&1;
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
