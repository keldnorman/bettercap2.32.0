# bettercap2.32.0

## Helper script to install Bettercap version 2.32.0 on Kali 

```
git clone https://github.com/keldnorman/bettercap2.32.0
cd bettercap2.32.0/
bash ./build_bettercap_2.32.0.sh
```

Then just go to http://127.0.0.1 and login with the user and password : user / pass

Change the password and user by editing the file called:
```/usr/local/share/bettercap/caplets/http-ui.cap```

![Screenshot of Bettercap 2.32.0](https://github.com/keldnorman/bettercap2.32.0/blob/main/bettercap2.32.0.png?raw=true)

```This is how the installation and compilation looks:
# bash ./build_bettercap_2.32.0.sh

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

--------------------------------------------------------
Downloading Bettercap v.2.32.0                    [OK]
Extracting v2.32.0.tar.gz                         [OK]
Deleting the v2.32.0.tar.gz file                  [OK]
--------------------------------------------------------
Compiling Bettercap version 2.32.0                
--------------------------------------------------------
@ Building for all ...

@ Building linux/amd64 ...
@ Creating archive bettercap_linux_amd64_2.32.0.zip ...
ping: arc.local: Name or service not known
@ Virtual machine host arc.local not visible !
--------------------------------------------------------
Unzipping Bettercap version 2.32.0                [OK]
--------------------------------------------------------
Downloading Bettercap http userinterface

bettercap v2.32.0 (built for linux amd64 with go1.22.3) [type 'help' for a list of commands]

[inf] gateway monitor started ...
[inf] caplets downloading caplets from https://github.com/bettercap/caplets/archive/master.zip ...
[inf] caplets installing caplets to /usr/local/share/bettercap/caplets ...
[inf] ui checking latest stable release ...
[inf] ui downloading ui v1.3.0 from https://github.com/bettercap/ui/releases/download/v1.3.0/ui.zip ...
[war] ui removing previously installed UI from /usr/local/share/bettercap/ui ...
[inf] ui installing to /usr/local/share/bettercap/ui ...
[inf] ui installation complete, you can now run the http-ui (or https-ui) caplet to start the UI.

--------------------------------------------------------
Starting Bettercap..                              
--------------------------------------------------------

###################################################
#                                                 #
#   ::: The web interface can be found here :::   #
#                                                 #
#                 http://127.0.0.1                #
#                                                 #
#     Login is: "user" and Password is: "pass"    #
#                                                 #
###################################################

# TIP: Next time just run:

/data/source/Bettercap/bettercap2.32.0/bettercap-2.32.0/build/bettercap -caplet http-ui

bettercap v2.32.0 (built for linux amd64 with go1.22.3) [type 'help' for a list of commands]

[23:57:08] [sys.log] [inf] gateway monitor started ...
[23:57:08] [sys.log] [inf] api.rest api server starting on http://127.0.0.1:8081
[23:57:08] [sys.log] [inf] http.server starting on http://127.0.0.1:80```
