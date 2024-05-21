#!/bin/bash
clear
#set -x
#--------------------------------------------------
# Banner for the 1337'ishness
#--------------------------------------------------
cat << "EOF"

 B E T T E R C A P 

Try: --proxy \
     --proxy-module injecthtml \
     --html-data "<img src='file://10.0.0.67/aaa/bbb.jpg'/>" \
     -T 10.0.0.33

EOF
#--------------------------------------------------
# VARIABLES
#--------------------------------------------------
BETTERCAP="/data/source/Bettercap/bettercap2.32.0/bettercap-2.32.0/build/bettercap"
#--------------------------------------------------
# PRE 
#--------------------------------------------------
if [ ${UID} -ne 0 ]; then 
 printf "\n### ERROR - This script must run as user root\n\n"
 exit 1
fi
#--------------------------------------------------
# SET USER AND PASSWORD
#--------------------------------------------------
if [ ! -x ${BETTERCAP} ]; then 
  printf " ### ERROR - Cant find ${BETTERCAP}\n\n"
  exit 1
fi
CAP_DIR="/usr/local/share/bettercap/caplets"
for CAP in ${CAP_DIR}/http-ui.cap ${CAP_DIR}/https-ui.cap; do
 if [ ! -s ${CAP} ]; then 
  printf "\nUpdating the http GUI..\n" 
  /usr/bin/bettercap -eval "caplets.update; ui.update; q"
  if [ ! -s ${CAP} ]; then 
   printf "\n### ERROR - Cant find ${CAP}\n\n"
   exit 1
  fi
 fi
 sed -i 's/set api.rest.username user/set api.rest.username user/' ${CAP}
 sed -i 's/set api.rest.password pass/set api.rest.password pass/' ${CAP}
done
#--------------------------------------------------
# UNBLOCK WIFI
#--------------------------------------------------
/usr/sbin/rfkill unblock wifi >/dev/null 2>&1
#--------------------------------------------------
# PREPARE WIFI
#--------------------------------------------------
for WLAN in $(iw dev | grep Interface | awk '{print $2}'); do
 iw ${WLAN} set monitor control >/dev/null 2>&1
 ifconfig ${WLAN} up >/dev/null 2>&1
done
#--------------------------------------------------
# STOP USE OF PORT 80
#--------------------------------------------------
service apache2 stop
#--------------------------------------------------
# DELAY START FIREFOX
#--------------------------------------------------
# sleep 5 && /usr/sbin/runuser -u ${USER} -- firefox http://127.0.0.1:80 &
# firefoxpid=$!
#--------------------------------------------------
# TURN OFF LED (works after next boot)
#--------------------------------------------------
if [ ! -f /etc/modprobe.d/alfa_led_off.conf ]; then 
 echo 'options 88XXau rtw_led_ctrl=0' > /etc/modprobe.d/alfa_led_off.conf
fi
#--------------------------------------------------
# USE BEST WIFI FOR PROBING
#--------------------------------------------------
adapters=$(iw dev | grep Interface | awk '{print $2}')
# Check if any adapters were found
if [ -z "$adapters" ]; then
 echo "No wireless adapters found."
 exit 1
fi
# Display the list of adapters and prompt the user to choose one
PS3="Please select a wireless adapter: "
select adapter in $adapters; do
 if [ -n "$adapter" ]; then
  WIFI="set wifi.interface ${adapter}; wifi.recon on"
  break
 else
  echo "Invalid selection. Please try again."
 fi
done
# Check if NetworkManager is installed
if command -v nmcli >/dev/null 2>&1; then
 if [ $(nmcli device show $adapter | grep GENERAL.STATE|tr -d '('|tr -d ')'|awk '{print $3}'|grep -c unmanaged) -ne 1 ]; then
  printf "\n%-50s" "Setting $adapter to be unmanaged" 
  nmcli device set $adapter managed no  
  printf "[OK]\n\n"
  trap 'nmcli device set $adapter managed yes' exit
 fi
fi
#--------------------------------------------------
# START WITH GPS IF PRESENT
#--------------------------------------------------
if [ -L /dev/ttyUSB-GPS ]; then 
 ${BETTERCAP} -caplet http-ui -eval "set gps.device /dev/ttyUSB-GPS ; gps on;sleep 5;gps.show;${WIFI}" 
else
 ${BETTERCAP} -caplet http-ui
fi
#--------------------------------------------------
# CLEANUP
#--------------------------------------------------
kill ${firefoxpid} 2>/dev/null
#--------------------------------------------------
# END OF SCRIPT
#--------------------------------------------------
