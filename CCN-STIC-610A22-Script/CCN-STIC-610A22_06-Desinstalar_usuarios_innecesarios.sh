#!/bin/bash
echo "---------------------------------------"
echo "--DESINSTALANDO USUARIOS INNECESARIOS--"
echo "---------------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar....."

cat /etc/shells|grep -q "/sbin/shutdown"

	if ! [[ $? = 0 ]]; then
	
		echo "/sbin/shutdown" >> /etc/shells
	fi

cat /etc/shells|grep -q "/sbin/halt"

	if ! [[ $? = 0 ]]; then
	
		echo "/sbin/halt" >> /etc/shells
	fi
	
########################################
#userdel -r netdump
#userdel -r sync
#userdel -r rpc
#userdel -r dbus
#userdel -r gopher
#userdel -r ftp #si desinstalamos el ftp
groupdel games
groupdel floppy
userdel games
#userdel -r lp
#userdel -r uucp
#userdel -r pcap
#userdel -r haldaemon
#userdel -r sshd #si desinstalamos el ssh
#userdel -r mail
#userdel -r chrony
#userdel -r geoclue
#chsh -s /bin/bash root

########################################
sleep 2
cat /etc/passwd | cut -d ":" -f1,2,3,4,6> /Scripts/rcs.txt

for LOGIN in `awk -F: '( $3 >= 1 && $3 < 1000 ) { print $1 }' /Scripts/rcs.txt`
do
   echo $LOGIN
   usermod -s /bin/false $LOGIN
done

sleep 2
rm -f /Scripts/rcs.txt
########################################
chsh -s /sbin/shutdown shutdown
chsh -s /sbin/halt halt
usermod -s /bin/false root
usermod -s /bin/false nobody