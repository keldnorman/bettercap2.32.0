/bin/bash
# By Keld Norman, 2024  - Version 0.1
clear
#--------------------------------------------------------
# Banner for the 1337'ishness
#--------------------------------------------------------
cat << "EOF" 

   @@@@@@                            @@@@@@   
 @@-----=@@          @@@@          @@*-----@@ 
@@----=@@-@@  @@@@%%%%%%%%%%@@@@  @@-@@+----@@
@@------@@@@@%%%%%%%%#-.%.#%%%%%%@@@@@------@@
@@----%@@@@@@@%%%%%%%#-.%.#%%%%%%%%%%@@=----@@
 @@--@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%@@@@@--@@ 
  @@@@....@@@@%%%%%%%%%%%%%%%%%%@@@@=...@@@@  
    @:..@@#........:@----@:........@@@..:@    
    @..@@@@.........@----@........-@@@@..@    
   @@...............@----@...............@@   
   @-@.............@------@.............@-@   
  @@--@@.........@@-@@@@@@-@@.........@@--@@  
  @@@---=@@@@@@@=-#@@@@@@@@@-=@@@@@@@=----+@  
  @@@@@#-----=@@@@%%%%%%%%%%@@@@=------%@@%@  
  @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@  
  @%%%@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@  
  @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@  
   @@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%%%%%%@    
          @@@@@@@@@%%%%%%%%%%%%%%@@@          

Bettercap version 2.32.0 Installer script 2024

EOF
#--------------------------------------------------------
# Ensure we run as root
#--------------------------------------------------------
if [ ! ${UID} -eq 0 ]; then 
 printf "Run this as user root or with sudo in front\n\n"
 exit 1
fi
#--------------------------------------------------------
# PRE INSTALL UTILS NEEDED
#--------------------------------------------------------
# Install wget
if [ ! -x /usr/bin/wget ]; then 
 printf "%-50s" "Installing wget.."
 apt-get update -y -qq > /dev/null 2>&1  && apt-get install -y -qq wget >/dev/null 2>&1
 if [ -x /usr/bin/wget ]; then 
  echo "[OK]"
 else
  echo "[FAILED]"
  exit 1
 fi
fi
# Install unzip
if [ ! -x /usr/bin/unzip ]; then 
 printf "%-50s" "Installing unzip.."
 apt-get update -y -qq > /dev/null 2>&1  && apt-get install -y -qq unzip >/dev/null 2>&1
 if [ -x /usr/bin/unzip ]; then 
  echo "[OK]"
 else
  echo "[FAILED]"
  exit 1
 fi
fi
# Install libpcap0.8-dev
if [ ! -s /usr/include/pcap.h ]; then
 printf "%-50s" "Installing libcap0.8-dev"
 apt-get update -y -qq > /dev/null 2>&1  && apt-get install -y -qq libpcap0.8-dev >/dev/null 2>&1
 if [ ! -s /usr/include/pcap.h ]; then
  echo "[OK]"
 else
  echo "[FAILED]"
  exit 1
 fi
fi
# Install libusb-1.0-0-dev
if [ $( dpkg -l libusb-1.0-0-dev 2>/dev/null|grep -c "^ii  libusb-1.0-0-dev" ) -eq 0 ]; then 
 printf "%-50s" "Installing libusb-1.0-0-dev"
 apt-get update -y -qq > /dev/null 2>&1  && apt-get install -y -qq libusb-1.0-0-dev >/dev/null 2>&1
 if [ $( dpkg -l libusb-1.0-0-dev 2>/dev/null|grep -c "^ii  libusb-1.0-0-dev" ) -ne 0 ]; then 
  echo "[OK]"
 else
  echo "[FAILED]"
  exit 1
 fi
fi
# Install libnetfilter-queue-dev
if [ $(cat /etc/os-release |grep -c -i kali ) -ne 0 ]; then 
if [ $(dpkg -l libnetfilter-queue-dev 2>/dev/null|grep -c "^ii  libnetfilter-queue-dev") -eq 0 ]; then
 printf "%-50s" "Installing libnetfilter-queue-dev"
 apt-get update -y -qq > /dev/null 2>&1  && apt-get install -y -qq wget >/dev/null 2>&1
 if [ $(dpkg -l libnetfilter-queue-dev 2>/dev/null|grep -c "^ii  libnetfilter-queue-dev") -ne 0 ]; then
  echo "[OK]"
 else
  echo "[FAILED]"
  exit 1
 fi
fi
fi
#--------------------------------------------------------
# Download bettercap version 2.32.0
#--------------------------------------------------------
printf -- "--------------------------------------------------------\n"
printf "%-50s" "Downloading Bettercap v.2.32.0"
wget --continue --quiet https://github.com/bettercap/bettercap/archive/refs/tags/v2.32.0.tar.gz
if [ ! -s ./v2.32.0.tar.gz ]; then 
 echo "[FAILED]"
 printf "\n### ERROR - Failed to wget https://github.com/bettercap/bettercap/archive/refs/tags/v2.32.0.tar.gz\n\n"
 exit 1
else
 echo "[OK]"
fi
#--------------------------------------------------------
# Check if filesize is correct after downloading the file
#--------------------------------------------------------
#printf "%-50s" "Validating downloaded file size"
#FILESIZE=$(du -sb ./v2.32.0.tar.gz |awk '{print $1}')
#if [ ${FILESIZE:-0} -ne 1355310 ]; then 
# echo "[FAILED]"
# printf "\n### ERROR - File is not the expected size of 1355310 bytes (du -sb ./v2.32.0.tar.gz)\n\n"
# exit 1
#else
# echo "[OK]"
#fi
#--------------------------------------------------------
# Remove old directory if it exist
#--------------------------------------------------------
if [ -d ./bettercap-2.32.0 ]; then 
 printf "%-50s" "Deleting old source code directory"
 rm -Rf ./bettercap-2.32.0
 echo "[OK]"
fi
#--------------------------------------------------------
# Extract the source code
#--------------------------------------------------------
printf "%-50s" "Extracting v2.32.0.tar.gz"
tar -zxf ./v2.32.0.tar.gz 
# Check the directory size after extracting the source code from the .tar.gz file
#DIRSIZE=$(du -bs ./bettercap-2.32.0|awk '{print $1}')
#if [ ${DIRSIZE:-0} -ne 4579995 ]; then 
# echo "[FAILED]"
# printf "\n### ERROR - Extracted directory size is not the expected 4579995 bytes (du -bs ./bettercap-2.32.0)\n\n"
# exit 1
#else
 echo "[OK]"
 # If size is OK then delete the tar.gz file
 printf "%-50s" "Deleting the v2.32.0.tar.gz file"
 rm ./v2.32.0.tar.gz
 echo "[OK]"
#fi
#--------------------------------------------------------
# Enter the directory where the source code is
#--------------------------------------------------------
cd bettercap-2.32.0
#--------------------------------------------------------
# Build all the binaries 
#--------------------------------------------------------
printf -- "--------------------------------------------------------\n"
printf "%-50s\n" "Compiling Bettercap version 2.32.0"
printf -- "--------------------------------------------------------\n"
./build.sh all
if [ ! -s ./build/bettercap_linux_amd64_2.32.0.zip ]; then 
 printf "\n### ERROR - Compile failed (cant find ./bettercap-2.32.0/build/bettercap_linux_amd64_2.32.0.zip)\n\n"
 exit 1
fi
#--------------------------------------------------------
# Unzipping build bettercap
#--------------------------------------------------------
cd build
printf -- "--------------------------------------------------------\n"
printf "%-50s" "Unzipping Bettercap version 2.32.0"
unzip -qq ./bettercap_linux_amd64_2.32.0.zip 
if [ ! -s ./bettercap ]; then 
 echo "[FAILED]"
 printf "\n### ERROR - Cant find ./bettercap-2.32.0/build/bettercap\n\n"
 exit 1
fi
#if [ $(du -b ./bettercap|awk '{print $1}') -ne 35889912 ]; then 
# echo "[FAILED]"
# printf "\n### ERROR - The compiled bettercap is not the expected size of 35889912 bytes (du -bs ./bettercap-2.32.0/build/bettercap)\n\n"
# exit 1
#fi
echo "[OK]"
printf -- "--------------------------------------------------------\n"
#--------------------------------------------------------
# Download bettercap web interface
#--------------------------------------------------------
printf "%-50s\n\n" "Downloading Bettercap http userinterface"
./bettercap -eval "caplets.update; ui.update; q" 
printf -- "--------------------------------------------------------\n"
printf "%-50s\n" "Starting Bettercap.."
printf -- "--------------------------------------------------------\n\n"
printf "###################################################\n"
printf "#                                                 #\n"
printf "#   ::: The web interface can be found here :::   #\n"
printf "#                                                 #\n"
printf "#                 http://127.0.0.1                #\n"
printf "#                                                 #\n"
printf "#     Login is: \"user\" and Password is: \"pass\"    #\n"
printf "#                                                 #\n"
printf "###################################################\n"
printf "\n# TIP: Next time just run: $(pwd)/bettercap -caplet http-ui\n\n"
./bettercap -caplet http-ui
