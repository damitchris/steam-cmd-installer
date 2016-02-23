#!/bin/sh

echo ------- Do you wish to install the dependencies ? [y or n] -------
read -r h
if test "$h" = "y"
then
  echo ------- This will install the required dependencies -------
  sudo apt-get install lib32gcc1
fi

# the code that verifies your architecture is not mine, this has been made by Makeklat00, go check out his version of the installer here:https://github.com/MakeKlat00/steamcmd-multi-srv/blob/master/steamcmd-install.sh,other than that the rest is my work
if [[ "getconf LONG_BIT" == '64' ]]; then
  echo ------- It seems that you are running a 64 bit version of linux, we are going to install 32 bit requirement -------
  dpkg --add-architecture i386 && apt-get update && apt-get install -y ia32-libs ia32-libs-gtk
fi

insdir="$1"
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
tar -xvzf steamcmd_linux.tar.gz

# Make it executable
chmod +x steamcmd.sh

echo ------- Do you wish to install a game now ? [y or n] -------
read -r h
   
if test "$h" = "y"
then
  echo ------- Input your username for steam, or login as anonymous -------
  read -r a
else
  echo ------- Running steam update check -------
  ./steamcmd.sh +quit
  exit
fi

if test "$a" = "anonymous"
then
  echo ------- Game appid you wish to install -------
  read -r c
  echo ------- Game path in the folder $insdir -------
  read -r d
  mkdir $insdir/$d
  ./steamcmd.sh +login $a +force_install_dir $insdir/$d +app_update $c validate
else
  echo ------- Password of the username you entered -------
  read -r b
  echo ------- Game appid you wish to install -------
  read -r c
  echo ------- Game path in the folder $insdir -------
  read -r d
  mkdir $insdir/$d
  ./steamcmd.sh +login $a $b +force_install_dir $insdir/$d +app_update $c validate
fi

exit
