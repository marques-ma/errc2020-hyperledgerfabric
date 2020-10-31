#!/bin/bash
clear
echo -e 'Preparando... \n'
cd /
#echo -e 'Digite a senha de root: '
#sudo -s
sudo mkdir tempdown

# Instala GIT e cUrl
echo -e '\nInstalando GIT e cUrl... \n'
sudo apt install git
sudo apt install curl

# Instala Docker
echo -e '\nInstalando Docker... \n'
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Adiciona usuário ao grupo docker
echo -e '\nAdiciona usuário ao grupo docker... \n'
echo -e "\nDigite o nome do usuario: "
read username
sudo usermod -a -G docker $username

# Instala Docker Compose
echo -e "\nInstalando Docker Compose...\n"
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Instala binários do Hyperledger Fabric / Clona fabric samples
echo -e "\nInstalando binários do Hyperledger Fabric e fabric samples...\n"
curl -sSL https://bit.ly/2ysbOFE | bash -s

# Instala Node
echo -e "\nInstalando Node...\n"
cd tempdown
VERSION=v12.19.0
DISTRO=linux-x64
wget https://nodejs.org/dist/v12.19.0/node-$VERSION-$DISTRO.tar.xz
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs

# Instala Go
echo -e "\nInstalando Go...\n"
wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz

# Instala NPM
echo -e "\nInstalando NPM...\n"
apt install npm

# Instala SSH
echo -e "\nInstalando SSH...\n"
sudo apt-get install openssh-server
sudo service ssh status

# Adiciona configs no bashrc
echo -e "\nAdicionando configs no bashrc...\n"
echo '# Hyperledger Fabric binaries' >> ~/.bashrc
echo 'export PATH=/fabric-samples/bin:$PATH' >> ~/.bashrc

echo '# Nodejs' >> ~/.bashrc
echo 'VERSION=v12.19.0' >> ~/.bashrc
echo 'DISTRO=linux-x64' >> ~/.bashrc
echo 'export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH' >> ~/.bashrc

echo '# Go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc





echo -e 'Instalação de pré-requisitos finalizada. \n'
