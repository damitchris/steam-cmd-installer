#!/bin/bash

## Change insdir="$PWD" if you want to use the script folder
insdir="$1"
user=""
pass=""
dir=""
appid=""
appmod=""
bool=""
chkhash=""
archit=""

function getInput()
{
  local rez=""
  echo ------- $1 -------
  read -r rez
  while [ -z "$rez" ]; do
    echo ------ Please put $2 ------
    read -r rez
  done
  eval "$3=$rez"
}
echo this scrip also has now maintenance capabilities,do you wish install ot maintain your server? inst or maint
read -r mai
if test "$mai" == "maint"
then
 echo this will help you maintain the server such as update functions, backups, and restore, this code will contain modified code of my own, so fell free to republish it as long that you give me credit.
 echo what would you like to do? backup or update
 read -r functions
 while [ -z "$functions" ]; do
     echo ------ Please give an input ------
     read -r functions
 done
 if test "$functions" == "backup"  
 then 
 now=$(date +"%m-%d-%y")
 if [ -z "$now" ]; then
   echo "an error occured while trying to retrieve the date, do it without a date? y or n"
   read -r dateerr
   while [ -z "$dateerr" ]; do
     echo ------ Please give an input ------
     read -r dateerr
   done
   if test "$dateerr" = "y"
   then
    echo we will generate a random number for the file
    now= $RANDOM
    daterr= yes
   else
    echo we are sorry it didnt worked, you can go to the github page to report it
    exit
   fi
 fi
 awnser=y
 if test "$awnser" = "y"
 then
   echo in which folder your server resides,specify the full path!
   read -r path
   while [ -z "$path" ]; do
     echo ------ Please give a path ------
     read -r path
   done
    notown=1
   fi
   echo OK, would you like it hidden from the user?you will need to do ls -a to see it. y or n
   read -r cloak
   while [ -z "$cloak" ]; do
     echo ------ Please give a awnser ------
     read -r cloak
   done
   if test "$cloak" = "y"; then
     mkdir ~/.backup
     cd ~/.backup
     tar -cvzf Backup_$now.tar.gz $path
     touch sums_$now.txt
     md5sum Backup_$now.tar.gz  | cut -c -32 > sums_$now.txt
     oldy=y
     if test "$oldy" = "y"
     then
       touch olddir_$now.txt
       echo $path > olddir_$now.txt
       echo old directory saved
     fi
   else
     mkdir ~/backup
     cd ~/backup
     tar -cvzf Backup_$now.tar.gz $path
     touch sums_$now.txt
     md5sum Backup_$now.tar.gz | cut -c -32 >  sums_$now.txt
     oldy=y
     if test "$oldy" = "y"
     then
       touch olddir_$now.txt
       echo $path > olddir_$now.txt
       echo old directory saved
     fi
   fi
 fi
 if test "$functions" == "update" 
 then
  echo put the appid of the server
  read -r appid
  while [ -z "$appid" ]; do
   echo ------ Please give an input ------
   read -r appid
  done
  echo input your username, you can log as anonymous.
  read -r username
  while [ -z "$username" ]; do
   echo ------ Please give an input ------
   read -r username
  done
  if test "$username" == "anonymous"
  then
   echo the script will log as anonymous
  else 
   echo input your password
   read -r password
   while [ -z "$password" ]; do
     echo ------ Please give an input ------
     read -r password
   done
  fi
  if [ -d "steamcmd" ]; then
   echo steamcmd exist
   cd /home/$USER/steamcmd
  else
   echo "steamcmd does not exist do you wish to install steamcmd?y or n"
   read -r steamcm
   while [ -z "$steamcm" ]; do 
    echo please try again
    read -r steamcm
   done
   if test "$steamcm" == "y"
   then
     echo ------- Downloading steam -------
     mkdir /home/$USER/steamcmd
     cd /home/$USER/steamcmd
     wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
     tar -xvzf steamcmd_linux.tar.gz
     chmod +x steamcmd.sh
   fi
  fi
  ./steamcmd.sh +login $username $password +app_update $appid +quit
  exit 0
 fi
fi
 

echo ------------ This script installs SteamCMD dedicated servers ------------

echo ------- Do you want to install dependencies ? [y or n] -------
read -r bool
if test "$bool" = "y"
then
  archit=$(uname -m)
  echo ------- You are using $archit linux kernel -------
  if [[ "$archit" == "x86_64" ]]; then
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install lib32gcc1
    sudo apt-get install lib32stdc++6
  else
    sudo apt-get install lib32gcc1
  fi
fi

if [ -n "$insdir" ]; then
  echo ------- Making directory /steamcmd at $insdir -------
else
  echo ------- Making directory /steamcmd at /home/$USER -------
  insdir="/home/$USER"
fi

# Making a directory and switching into it
mkdir $insdir/steamcmd
cd $insdir/steamcmd

echo ------- Downloading steam -------
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

chkhash=$(md5sum steamcmd_linux.tar.gz | cut -d' ' -f1)
if test "$chkhash" == "09e3f75c1ab5a501945c8c8b10c7f50e" 
then
  echo ----- Checksum OK -------
else
  echo ----- Checksum FAIL ------- $chkhash
  exit 0
fi

tar -xvzf steamcmd_linux.tar.gz

# Make it executable
chmod +x steamcmd.sh

echo ------- Do you wish to install a game now ? [y or n] -------
read -r bool
   
if test "$bool" == "y"
then
  getInput "Enter a user for steam, or login as anonymous" "user name" user
else
  echo ------- Running steam update check -------
  ./steamcmd.sh +quit
  exit 0
fi

if test "$user" == "anonymous"
then
  getInput "Which appid you wish to install ?" "appid" appid
  if test "$appid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
    getInput "Do you need to install a mod for HL1 / CS1.6 ? [no or <mod_name>]" "a mod" appmod
  fi
  getInput "Where in [$insdir] do you want to put it ?" "path" dir
  mkdir $insdir/$dir
  if test "$appmod" == "no"
  then
    ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +quit
  else
    ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
  fi
else
  getInput "What is the password for the user [$user] ?" "password" pass
  getInput "Which appid you wish to install ?" "appid" appid
  if test "$appid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
    getInput "Do you need to install a mod for HL1 / CS1.6 ? [no or <mod_name>]" "a mod" appmod
  fi
  getInput "Where in [$insdir] do you want to put it ?" "path" dir
  mkdir $insdir/$dir
  if test "$appmod" == "no"
  then
    ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +quit
  else
    ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
  fi
fi

exit 0
