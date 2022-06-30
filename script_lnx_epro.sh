#!/bin/sh
#
# Nome: script_lnx_epro.sh
# Autor: Rodrigo Greff
# Empresa: E-tab Tecnologia e Gestão
#
# Comentário: Script para criar o ambiente de Produção do sistema E-PRO e Solução Notarial.

# Atualizar repositórios 
apt-get update -y

# Alterar timezone
timedatectl set-timezone America/Sao_Paulo

#  Passos para a instalção do SQL Server

# Importe as chaves GPG do repositório público
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Registre o repositório do Ubuntu do SQL Server
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-preview.list)"

# Execute os comandos a seguir para instalar o SQL Server
apt-get install -y mssql-server

# Escolher sua edição do SQL Server e definir a senha do usuário SA
sudo /opt/mssql/bin/mssql-conf setup

# verifique se o serviço está em execução
systemctl status mssql-server --no-pager

# Instalar as ferramentas de linha de comando SQL Server

# Etapas a seguir para instalar o mssql-tools no Ubuntu e o curl 
apt-get install curl -y

# Importe as chaves GPG do repositório público.
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Registre o repositório do Ubuntu
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

# Atualize a lista de fontes e execute o comando de instalação com o pacote do desenvolvedor do unixODBC
apt-get install mssql-tools unixodbc-dev -y

# Atualizar para a versão mais recente do mssql-tools
sudo apt-get update -y
sudo apt-get install mssql-tools -y

# Adicione /opt/mssql-tools/bin/ à variável PATH de ambiente para tornar o sqlcmd ou bcp acessível no shell bash
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

# Criação de diretório
mkdir /home/adminetab/epro
mkdir /home/adminetab/sn

# Dar permissão no diretório 
chmod 777 -R /home/adminetab/epro/
chmod 777 -R /home/adminetab/sn/

# Instalar o Samba
apt-get install samba -y

# Add usuário do SO ao Samba 
smbpasswd -a adminetab

# Instalar FTP
apt-get install vsftpd -y

# Criar usuário FTP
adduser ftpepro

# Parar os serviços antes de alterar os arquivos de configuração
systemctl stop vsftpd.service
systemctl stop smbd.service

# Substituir arquivos de configurações
cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp
cp /etc/vsftpd.conf /etc/vsftpd.conf.bkp 
rm /etc/vsftpd.conf
mv -f smb.conf /etc/samba/smb.conf
mv -f vsftpd.conf /etc/vsftpd.conf

# Iniciar os serviços 
systemctl start smbd.service
systemctl start vsftpd.service




