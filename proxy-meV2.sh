#!/bin/bash
clear
N='\033[0m'
R='\033[0;31m'
G='\033[0;32m'
O='\033[0;33m'
B='\033[0;34m'
Y='\033[0;38m'       # Yellow
C='\033[0;36m'       # Cyan
W='\033[0;37m'
function banner() {
echo -e "
${N}██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗     ███╗    ███╗███████╗
${G}██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝     ████╗  ████║██╔════╝
${R}██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝█████╗██╔████╔██║█████╗  
${B}██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝ ╚════╝██║╚██╔╝██║██╔══╝  
${O}██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║        ██║ ╚═╝ ██║███████╗
${Y}╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝        ╚═╝     ╚═╝╚══════╝
${G}Designed By Krishanu Sharma & Vivek
       ${R}An Advance Tool By Indian Cyber Troops
${O}An Automated Proxy Scrapper
${B}A New Way To Gain Information In New Era                                               
"
}
banner
if [[ $EUID -ne 0 ]]; then
   echo -e " ${C} This script must be run as root To Install Some Packages" 
   exit 1
fi
# Declare an array of proxy sources
declare -a sources=(
    "https://www.proxy-list.download/api/v1/get?type=http"
    "https://api.proxyscrape.com/v2/?request=getproxies&protocol=http&timeout=10000&country=all"
    "https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt"
    "https://raw.githubusercontent.com/hookzof/socks5_list/master/proxy.txt"
    "https://www.proxy-list.download/api/v1/get?type=https"
    "https://api.proxyscrape.com/v2/?request=getproxies&protocol=https&timeout=10000&country=all"
    "https://raw.githubusercontent.com/TheSpeedX/SOCKS-List/master/http.txt"
    "https://raw.githubusercontent.com/hookzof/socks5_list/master/proxy.txt"
    "https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt"
    "https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/https.txt"
)

# Loop through each proxy source and fetch the proxies
for source in "${sources[@]}"
do
    echo "Fetching proxies from Internet..."
    proxies=$(curl -s "$source")
    echo "$proxies" >> proxy.txt
done

# Test the proxies and save the working ones
echo "Testing proxies ..."
echo "It Will Take Time to Test All Result Proxies Wait Till Tool Check proxies ..."
while read line; do
    proxy=$(echo $line | tr -d '\r')
    curl --proxy $proxy --connect-timeout 5 --max-time 10 --silent --head https://www.google.com > /dev/null
    if [ $? -eq 0 ]; then
        echo "$proxy is working"
        echo "$proxy" >> working_proxies.txt
    fi
done < proxy.txt

# Cleanup
rm proxy.txt

# Echo the result
echo "Done. The working proxies are saved in working_proxies.txt"
