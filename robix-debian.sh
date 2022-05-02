#!/bin/bash

set -e #Qualquer comando que retorar erro irá encerrar a execução do script

clear
echo "################################################################################"
echo "###                                                                          ###"
echo "###                    Instalando os pacotes necesários                      ###"
echo "###                                                                          ###"
echo "################################################################################"
echo ""
echo "---> Adicionando o suporte a arquitetura de 32bits <---"
echo ""
sudo dpkg --add-architecture i386
echo ""
echo "---> Atualizando a lista de programas <---"
echo ""
sudo apt update
echo ""
echo "---> Atualizando o sistema operacional <---"
echo ""
sudo apt upgrade -y
echo ""
echo "---> Instalando wget para fazer download de arquivos <---"
echo ""
sudo apt install wget -y
echo ""
echo "---> Instalando dependência openjdk-11-jre (32 e 64 bits) <---"
echo ""
sudo apt install openjdk-11-jre:i386 openjdk-11-jre -y
echo ""
echo "---> Instalando dependência libstdc++2.10 de 32bits  <---"
echo ""
wget -c https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/bin/libstdc++2.10-glibc2.2_2.95.4-27_i386.deb
#wget -c http://archive.debian.org/debian/pool/main/g/gcc-2.95/libstdc++2.10-glibc2.2_2.95.4-27_i386.deb #original
sudo apt install ./libstdc++2.10-glibc2.2_2.95.4-27_i386.deb
rm ./libstdc++2.10-glibc2.2_2.95.4-27_i386.deb

clear
echo "################################################################################"
echo "###                                                                          ###"
echo "###                     Instalando o Usbor (Robix)                           ###"
echo "###                                                                          ###"
echo "################################################################################"
echo "###                                                                          ###"
echo "###                               AVISO!                                     ###"
echo "###                                                                          ###"
echo "###                                                                          ###"
echo "###     No momento de selecionar o local de instalação, deixe o padrão:      ###"
echo "###                         /opt/Robix/Usbor/                                ###"
echo "###                                                                          ###"
echo "###   No momento de selecionar o local dos atalhos, também deixe o padrão:   ###"
echo "###                             /usr/bin/                                    ###"
echo "###                                                                          ###"
echo "###                                                                          ###"
echo "################################################################################"
echo ""
echo ""
echo ""
echo ""
read -e -p "Pressione ENTER depois de acabar de ler os avisos..."
echo ""
echo "---> Baixando o instalador <---"
echo ""
wget -c https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/bin/install_usbor-1.1.0.bin
echo ""
echo "---> Iniciando o instalador <---"
echo ""
chmod +x install_usbor-1.1.0.bin
sudo ./install_usbor-1.1.0.bin
rm ./install_usbor-1.1.0.bin

clear
echo "################################################################################"
echo "###                                                                          ###"
echo "###                             Pós instalação                               ###"
echo "###                                                                          ###"
echo "################################################################################"
echo ""
echo "---> Configurando path do java <---"
echo ""
sudo wget -O /opt/Robix/Usbor/bin/UsborNexus.config https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/config/UsborNexus.config
sudo wget -O /opt/Robix/Usbor/bin/UsborNexway.config https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/config/UsborNexway.config
echo ""
echo "---> Baixando os icones <---"
echo ""
sudo wget -O /opt/Robix/Usbor/nexus.png  https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/icons/nexus.png
sudo wget -O /opt/Robix/Usbor/nexway.png https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/icons/nexway.png
echo ""
echo "---> Criando os atalhos no menu do sistema <---"
echo ""
sudo wget -O /usr/share/applications/robix-nexus.desktop  https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/desktop/robix-nexus.desktop
sudo wget -O /usr/share/applications/robix-nexway.desktop https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/desktop/robix-nexway.desktop

clear
echo "################################################################################"
echo "###                                                                          ###"
echo "###            Instalação do Usbor finalizada com sucesso                    ###"
echo "###                                                                          ###"
echo "################################################################################"
echo ""
