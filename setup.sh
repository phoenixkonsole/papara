#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your papara  masternodes.  *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
  sudo apt update
  sudo apt -y upgrade
  sudo apt -y dist-upgrade
  sudo apt update
  sudo apt install -y zip unzip

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  wget https://github.com/phoenixkonsole/papara/releases/download/v1.1.0.0/Linux.zip
  unzip Linux.zip
  chmod +x Linux/bin/*
  sudo mv  Linux/bin/* /usr/local/bin
  rm -rf Linux.zip Windows Linux Mac

  sudo apt install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

 ## Setup conf
 IP=$(curl -s4 api.ipify.org)
 mkdir -p ~/bin
 echo ""
 echo "Configure your masternodes now!"
 echo "Detecting IP address:$IP"

echo ""
echo "How many nodes do you want to create on this server? [min:1 Max:20]  followed by [ENTER]:"
read MNCOUNT


for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  

  echo ""
  echo "Enter port for node $ALIAS"
  read PORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  RPCPORT=$(($PORT*10))
  echo "The RPC port is $RPCPORT"

  ALIAS=${ALIAS}
  CONF_DIR=~/.papara_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/paparad_$ALIAS.sh
  echo "paparad -daemon -conf=$CONF_DIR/papara.conf -datadir=$CONF_DIR "'$*' >> ~/bin/paparad_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/papara-cli_$ALIAS.sh
  echo "papara-cli -conf=$CONF_DIR/papara.conf -datadir=$CONF_DIR "'$*' >> ~/bin/papara-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/papara-tx_$ALIAS.sh
  echo "papara-tx -conf=$CONF_DIR/papara.conf -datadir=$CONF_DIR "'$*' >> ~/bin/papara-tx_$ALIAS.sh 
  chmod 755 ~/bin/papara*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> papara.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> papara.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> papara.conf_TEMP
  echo "rpcport=$RPCPORT" >> papara.conf_TEMP
  echo "listen=1" >> papara.conf_TEMP
  echo "server=1" >> papara.conf_TEMP
  echo "daemon=1" >> papara.conf_TEMP
  echo "logtimestamps=1" >> papara.conf_TEMP
  echo "maxconnections=256" >> papara.conf_TEMP
  echo "masternode=1" >> papara.conf_TEMP
  echo "" >> papara.conf_TEMP

  echo "" >> papara.conf_TEMP
  echo "port=$PORT" >> papara.conf_TEMP
  echo "masternodeaddr=$IP:$PORT" >> papara.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> papara.conf_TEMP
  sudo ufw allow $PORT/tcp

  mv papara.conf_TEMP $CONF_DIR/papara.conf
  
  sh ~/bin/paparad_$ALIAS.sh
done
