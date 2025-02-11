#!/bin/bash
echo "---------------------------------"
echo "--ELIMINANDO PAQUETES HUÉRFANOS--"
echo "---------------------------------"
read -p "Pulse ENTER para continuar o Ctrl + C para cancelar....."
dnf install -y yum-utils
dnf autoremove
dnf clean all
dnf -y remove `package-cleanup --orphans`
dnf -y remove `package-cleanup --leaves`
