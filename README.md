# Robix Software no Linux

Para controlar seu [Robix](http://robix.com) é necessário a instalação do [pacote](http://www.robix.com/install_usbor-1.1.0.bin%20PLUS%20CRUCIAL%20README.zip) `Usbor` que vem com os softwares `Robix Nexus` e `Robix Nexway`. Ambos softwares de comunicam um com outro para controlar o Robix, sendo o`Robix Nexus` um servidor TCP/IP responsável por se comunicar com o Robix via USB e por receber conexões do `Robix Nexway`. Já o `Robix Nexway` por sua vez, é um cliente TCP/IP com uma interface gráfica para programação do Robix e que se conecta ao `Robix Nexus` para enviar comandos de movimentação ao Robix. Ambos softwares podem ser executados no mesmo computador se comunicando pelo localhost, ou pode ser executados em computadores separados onde um computador conectado ao Robix via USB executa o Nexus, logo, se transformando em um servidor, e então varios outros computadores poderão executar o Nexway e se conectarem ao servidor Nexus pela rede ethernet local, permitindo assim que varias pessoas trabalhem em conjunto controlando o mesmo robô.

Apesar dessa ótima abordagem no desenvolvimento do software, ela foi desenvolviva muitos anos atrás, em versões mais antigas do Kernel Linux, não oferecedndo suporte às distribuições Linux mais recentes. Este repositório fornece um script assistente de instalação para sistemas operacionais recentes baseados em Debian, como Ubuntu 22.04 por exemplo, bem como um manual de instalação passo a passo explicado para auxiliar a instalação em outras distribuições, ou caso o script não funcione.

## Introdução ao problema

Por ser programado em Java, o software `Robix Nexway` pode ser executado em diversas arquiteturas, como um Raspberry Pi que possui uma arquitetura ARM64, entretanto o software `Robix Nexus` possui bibliotecas C++ compiladas para x86, o que limita sua execução a esta arquitetura. Ele pode ser executado em um sistema operacional baseado em linux de 64 bits, mas para isso ele precisa ser executado através de uma versão de 32 bits do java.

Devido a última versão do `Usbor` (1.1) ser desenvolvida para a versão 2.6 do kernel linux, algumas bibliotecas compartilhadas podem não estar mais disponíveis nas versões atuais, como por exemplo para o kenel 5.x do Ubuntu 22.04, esse é o caso da libstdc++2.10, portanto é necessário instalar ela manualmente. Além disso, a maneira como o Kernel Linux se comunica com os dispositivos USB mudou, antigamente era usado o módulo `usbfs`, o qual foi substituido pela `libusb`, portanto é necessário emular a forma como `usbfs` funcionava para permitir a comunicação do Nexus com o Robix via USB.

O script resolve essas questões automaticamente para você, além de criar o atalho de desktop.

## Instalação automática (script assistente)

Execute o script assistente de instação com o comando abaixo:

```bash
curl https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/robix-debian.sh | sudo bash
```

Leia atentamente as mensagens do terminal a procura de algum erro, ou para seguir corretamente as instruções.

OBS: Caso o ```cURL``` não esteja instalado, execute o comando:

```bash
sudo apt install curl
```

## Instalação manual (passo a passo)

Caso o assistente de instalação não tenha funcionado por algum motivo, ou porque você ultiliza uma distribuição não baseada em Debian, você pode realizar a instalação manualmente seguindo esse passo a passo explicado, e então você mesmo poderá alterar os comandos e/ou tentar resolver qualquer problema que surja no meio do processo.

### Instalar dependência "Java Runtime" de 32bits

Você pode tentar instalar qualquer java (proprietário da Sun, ou openjdk), desde de que 32bits. Vou usar como exemplo a versão 11 do openjdk que está disponível para Ubuntu 22.04, Debian 11 e Debian 12, já que é a versão que eu testei e sei que funcionou.

Primeiro adicione o suporte a arquitetura de 32bits com o comando:

```bash
sudo dpkg --add-architecture i386 
```

Atualize a lista de programas, bem como o sistema operacional todo:

```bash
sudo apt update && sudo apt upgrade
```

Instale o `openjdk-11-jre` de 32 bits:

```bash
sudo apt install openjdk-11-jre:i386
```

Alternativamente, caso você precise instalar ambas versões de 32 e 64 bits do java, instale pelo comando abaixo:

```bash
sudo apt install openjdk-11-jre:i386 openjdk-11-jre
```

### Instalar Dependência `libstdc++2.10` de 32bits

`Usbor` depende de uma versão antiga da biblioteca `libstdc++`, que não é mais distribuída nos novos sistemas operacionais linux.

|  Biblioteca dependente     |  Provida pelo binário    |
|----------------------------|--------------------------|
|  libstdc++-libc6.2-2.so.3  |  libstdc++2.10-glibc2.2  |

Uma solução é baixar e instalar manualmente esta biblioteca através do comando abaixo.

```bash
wget -c https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/bin/libstdc++2.10-glibc2.2_2.95.4-27_i386.deb
sudo apt install ./libstdc++2.10-glibc2.2_2.95.4-27_i386.deb
```

OBS: Caso o ```wget``` não esteja instalado, execute o comando:

```bash
sudo apt install wget
```

### Instalar Robix Usbor

Primeiro baixe o instalador:

```Bash
wget -c https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/bin/install_usbor-1.1.0.bin
```

Dê permissão para executar:

```Bash
chmod +x install_usbor-1.1.0.bin
```

Instale o usbor usando privilégios administrativos:

```bash
sudo ./install_usbor.bin
```

No momento de selecionar o local de instalação, deixe o padrão:

```
/opt/Robix/Usbor/
```

No momento de selecionar o local dos atalhos, também deixe o padrão:

```
/usr/bin/
```

### Configurar path do java no Nexus

Como explicado anteriormente, o Nexus precisa necessariamente ser executado em uma máquina virtual java de 32 bits, devido que necessita executar bibliotecas 32bits de outras linguagens de programação.

Tanto Nexus quanto Nexway possuem um arquivo de configuração disponível na pasta ```/opt/Robix/Usbor/bin``` que permite selecionar o path do Java. Para isso, altere os arquivos abaixos adicionando o caminho para o path do java:

```Bash
sudo nano /opt/Robix/Usbor/bin/UsborNexus.config
```

Adicione a linha abaixo:

```
javapath /usr/lib/jvm/java-11-openjdk-i386/bin/java
```

Opcionalmente altere a path do java do nexway também para 32 bits colando a mesma linha acima no arquivo de configuração do Nexway:

```Bash
sudo nano /opt/Robix/Usbor/bin/UsborNexway.config
```

Esse é o caminho para o openjdk-11-jre de 32 bits. Caso você tenha instalado outra versão do java de 32 bits, corrija o caminho do path.

### Solucionar incompatibilidade do Nexus e o Executar

Como explicado anteriormente, o Robix Nexus usa usbfs para se comunicar com o hardware pelo USB, mas "Os sistemas modernos não usam usbfs; as entradas dentro dele são arquivos, não nós de dispositivo, e não suportam ACLs, que são a maneira padrão de fornecer acesso a dispositivos USB para usuários não confiáveis. Ele é substituído por nós de dispositivo mantidos pelo udev em /dev/bus/usb, o libusb usa esses nós de dispositivo." [(link para original)](https://markmail.org/message/3mw5yw465qmxgnwp)

O desenvolvedor do software orienta executar o comando `sudo mount --bind /dev/bus/usb /proc/bus/usb` para simular o funcionamento do usbfs, entretanto esse comando não funciona no Ubuntu 22.04, dando a mensagem de erro `mount: /proc/bus/usb: mount point does not exist`. É possível modificar levemente o comando para ele passar a funcionar.

#### Solução manual

Executando o comando abaixo antes de executar o Nexus permitirá a comunicação do mesmo com o Robix quando conectado via USB. Isso basicamente simula a estrutura padrão do usbfs até que o computador seja reiniciado.

```Bash
sudo mount --bind /dev/bus /proc/bus
```
Entretanto isso tem um problema, como o administrador que realizou o procedimento, a comunicação precisa de privilégios administrativos para acontecer, ou seja, o nexus deve ser executado como administrador para se comunicar com a placa:

```Bash
sudo UsborNexus
```

Já o programa Nexway não precisa de privilegios administrativos, logo pode executado como:

```Bash
UsborNexway
```

Se tudo ocorrer bem, pronto, você já é capaz de utilizar o Nexus e Nexway no mesmo computador. Mas se você não quiser executar comandos no terminal toda vez que for usar o robix, você pode criar atalhos que realizam o procedimento para você, conforme explicado na próxima sessão.

### Criar os atalho no menu do sistema

Para facilitar a execução do programa, crie atalhos no sistema.

Primeiro baixe os icones:

```Bash
sudo wget -O /opt/Robix/Usbor/nexus.png  https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/icons/nexus.png
sudo wget -O /opt/Robix/Usbor/nexway.png https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/icons/nexway.png
```

Agora crie o atalho do Nexway no local indicado:

```
sudo nano /usr/share/applications/robix-nexway.desktop
```

E então copie e cole o conteudo do [atalho](https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/desktop/robix-nexway.desktop) no editor de texto e salve.

Agora crie o atalho do Nexus no local indicado:

```
sudo nano /usr/share/applications/robix-nexus.desktop
```

Já o atalho para o Nexus será um pouco diferente, pois precisamos de privilégios administrativos e rodar um comando antes de executar o programa. Para isso usaremos o programa ```pkexec``` que irá solicitar a senha do root, e usaremos o ```sh``` para executar os comandos necessários. Apenas copie e cole o [atalho](https://raw.githubusercontent.com/LabRobotica/RobixLinux/main/desktop/robix-nexus.desktop) indicado.

Pronto, já é possível executar o Nexway e o Nexus apenas clicando no atalho no menu do sistema. Entretanto o Nexus irá pedir senha antes de ser executado.
