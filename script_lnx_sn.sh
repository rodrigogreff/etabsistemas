#!/bin/sh
#
# Nome: script_lnx_epro.sh
# Autor: Rodrigo Greff
# Empresa: E-tab Tecnologia e Gestão
#
# Comentário: Script para criar o ambiente de Produção do sistema Solução Notarial.

# Atualizar repositórios 
apt-get update 

# Alterar timezone
timedatectl set-timezone America/Sao_Paulo

# Passos para a instalção do SQL Server

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
apt-get update 
apt-get install mssql-tools unixodbc-dev -y

# Atualizar para a versão mais recente do mssql-tools
apt-get update 
sudo apt-get install mssql-tools -y

# Adicione /opt/mssql-tools/bin/ à variável PATH de ambiente para tornar o sqlcmd ou bcp acessível no shell bash
sudo ln -sfn /opt/mssql-tools//bin/sqlcmd /usr/bin/sqlcmd
sudo ln -sfn /opt/mssql-tools//bin/bcp /usr/bin/bcp

# Parar os serviços do SQL Server
sudo systemctl stop mssql-server

# Altere o agrupamento do SQL Server usando mssql-conf
sudo /opt/mssql/bin/mssql-conf set-collation 
SQL_Latin1_General_CP1_CI_AI

# Iniciar os serviços do SQL Server
sudo systemctl start mssql-server

# Criação de diretório
mkdir /home/useretab/system
mkdir /home/useretab/system/sn
mkdir /home/useretab/docs
mkdir /home/useretab/docs/sn
mkdir /home/useretab/docs/sn/Assinaturas
mkdir /home/useretab/docs/sn/Censec
mkdir /home/useretab/docs/sn/DcosImportados
mkdir /home/useretab/docs/sn/Documentos
mkdir /home/useretab/docs/sn/DocumentosCentralNotarial
mkdir /home/useretab/docs/sn/DOI
mkdir /home/useretab/docs/sn/FichasAntigas
mkdir /home/useretab/docs/sn/FolhasDeLivro
mkdir /home/useretab/docs/sn/Fotos
mkdir /home/useretab/docs/sn/IBGE
mkdir /home/useretab/docs/sn/Imagens
mkdir /home/useretab/docs/sn/ImagensBiometria
mkdir /home/useretab/docs/sn/Imoveis
mkdir /home/useretab/docs/sn/ISSQN
mkdir /home/useretab/docs/sn/LivroCaixa
mkdir /home/useretab/docs/sn/LivroDeRegistro
mkdir /home/useretab/docs/sn/Matrimonios
mkdir /home/useretab/docs/sn/QRCode
mkdir /home/useretab/docs/sn/Relatorios
mkdir /home/useretab/docs/sn/Selos
mkdir /home/useretab/docs/sn/SinalPublico
mkdir /home/useretab/docs/sn/TextosCorretos
mkdir /home/useretab/docs/sn/TextosEscrituras
mkdir /home/useretab/docs/sn/TextosEscriturasImportacao
mkdir /home/useretab/docs/sn/TransfVeiculos

# Dar permissão no diretório 
chmod 777 -R /home/useretab/system/sn/
chmod 777 -R /home/useretab/docs/sn/

# Instalar o Samba
apt-get install samba -y

# Add usuário do SO ao Samba 
smbpasswd -a useretab

# Parar os serviços antes de alterar os arquivos de configuração
systemctl stop smbd.service

# Substituir arquivos de configurações
cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp
mv -f smb.conf /etc/samba/smb.conf

# Iniciar os serviços 
systemctl start smbd.service

# Remover a pasta do projeto 
rm -rf /home/adminetab/UbuntuServer/



