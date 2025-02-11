#!/bin/bash
echo "----------------------------------------------------"
echo "-- SE ELIMINARÁN PROGRAMAS Y DRIVERS INNECESARIOS --"
echo "----------------------------------------------------"
echo
if [[ -d /sys/firmware/efi ]];
then
echo -e "Version \e[5;31m  UEFI  \e[0m detectada"
sleep 3
echo "Deberá adaptar la configuración de limites_archivos con los parámetros de su organización."
read -p "Presione ENTER para continuar si ha adaptado la configuración para UEFI o Ctrl + C para cancelar........"
fi
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar........"
dnf remove chrony.x86_64 firstboot.x86_64 speech-dispatcher.x86_64 postfix

dnf remove xinetd telnet-server rsh-server \
  telnet rsh ypbind ypserv tfsp-server bind \
  vsfptd dovecot squid net-snmpd talk-server talk
#Drivers de targetas de sonido, wifi, win tv etc..
dnf remove ivtv-* iwl*firmware aic94xx-firmware

echo "------------------------------------------------------------------------"
echo "-- RESTRINGIR EL MONTAJE Y DESMONTAJE DINÁMICO DE SISTEMAS DE ARCHIVOS--"
echo "------------------------------------------------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar........"
touch /etc/modprobe.d/limites_archivos.conf
cat > /etc/modprobe.d/limites_archivos.conf << EOF
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true
#Comentar en caso de instalacion EFI
install fat /bin/true
#Comentar en caso de instalacion EFI
install vfat /bin/true
install cifs /bin/true
install nfs /bin/true
install nfsv3 /bin/true
install nfsv4 /bin/true
install gfs2 /bin/true
install bnep /bin/true
install bluetooth /bin/true
install btusb /bin/true
install net-pf-31 /bin/true
EOF

gedit /etc/modprobe.d/limites_archivos.conf

#Drivers wifi
for i in $(find /lib/modules/$(uname -r)/kernel/drivers/net/wireless -name "*.ko*" -type f);do \
  echo blacklist "$i" >>/etc/modprobe.d/limites-wireless.conf;done

echo "-----------------------------------------------------------------------"
echo "-- SE DESHABILITARAN Y ENMASCARARÁN DEMONIOS Y PROCESOS INNECESARIOS --"
echo "-----------------------------------------------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar........"

systemctl mask bluetooth.target
systemctl mask printer.target
systemctl mask remote-fs.target
systemctl mask rpcbind.target
systemctl mask runlevel4.target
systemctl mask runlevel5.target
systemctl mask runlevel6.target
systemctl mask smartcard.target
systemctl mask sound.target
systemctl mask console-getty.service
systemctl mask debug-shell.service
systemctl mask rdisc.service
systemctl mask ctrl-alt-del.target
systemctl mask iprutils.target
systemctl mask fstrim.timer
systemctl mask container-getty@.service 
systemctl mask console-getty.service
systemctl mask kexec.target
systemctl mask cpupower.service
systemctl mask ebtables.service
systemctl mask dbus-org.freedesktop.hostname1.service
systemctl mask dbus-org.freedesktop.portable1.service
systemctl mask debug-shell.service
systemctl mask dracut-cmdline.service
systemctl mask dracut-initqueue.service
systemctl mask dracut-mount.service
systemctl mask dracut-pre-mount.service
systemctl mask dracut-pre-pivot.service
systemctl mask dracut-pre-trigger.service
systemctl mask dracut-pre-udev.service
systemctl mask dracut-shutdown.service
systemctl mask getty@.service
systemctl mask import-state.service
systemctl mask iprdump.service
systemctl mask iprinit.service
systemctl mask iprupdate.service
systemctl mask kmod-static-nodes.service
systemctl mask loadmodules.service
systemctl mask nftables.service
systemctl mask nis-domainname.service
systemctl mask plymouth-halt.service
systemctl mask plymouth-kexec.service
systemctl mask plymouth-poweroff.service
systemctl mask plymouth-quit-wait.service
systemctl mask plymouth-quit.service
systemctl mask plymouth-read-write.service
systemctl mask plymouth-reboot.service
systemctl mask plymouth-start.service
systemctl mask plymouth-switch-root.service
systemctl mask rdisc.service
systemctl mask rescue.service
systemctl mask serial-getty@.service
systemctl mask systemd-resolved.service
systemctl mask tuned.service


systemctl list-unit-files

##########################################################################################
echo "-------------------------------------------------"
echo "-- SE BLOQUEARÁN LOS COMPILADORES DEL SISTEMA  --"
echo "-------------------------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar........"
sudo chmod 000 /usr/bin/byacc 2>>/dev/null
sudo chmod 000 /usr/bin/yacc 2>>/dev/null
sudo chmod 000 /usr/bin/bcc 2>>/dev/null
sudo chmod 000 /usr/bin/kgcc 2>>/dev/null
sudo chmod 000 /usr/bin/cc 2>>/dev/null
sudo chmod 000 /usr/bin/gcc 2>>/dev/null
sudo chmod 000 /usr/bin/*c++ 2>>/dev/null
sudo chmod 000 /usr/bin/*g++ 2>>/dev/null

##########################################################################################
echo "------------------------------------------"
echo "-- EL EQUIPO SE REINICIARÁ EN 1 MINUTO  --"
echo "------------------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar........"
####################################"
shutdown -r
echo ">>>>Guarde los documentos que tenga abiertos y espere...<<<<"
