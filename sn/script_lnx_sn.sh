#!/bin/sh
#
# Nome: script_lnx_sn.sh
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

# Criação dos diretórios
mkdir /home/adminetab/system
mkdir /home/adminetab/system/sn
mkdir /home/adminetab/docs
mkdir /home/adminetab/docs/sn
mkdir /home/adminetab/docs/sn/Assinaturas
mkdir /home/adminetab/docs/sn/Censec
mkdir /home/adminetab/docs/sn/DcosImportados
mkdir /home/adminetab/docs/sn/Documentos
mkdir /home/adminetab/docs/sn/DocumentosCentralNotarial
mkdir /home/adminetab/docs/sn/DOI
mkdir /home/adminetab/docs/sn/FichasAntigas
mkdir /home/adminetab/docs/sn/FolhasDeLivro
mkdir /home/adminetab/docs/sn/Fotos
mkdir /home/adminetab/docs/sn/IBGE
mkdir /home/adminetab/docs/sn/Imagens
mkdir /home/adminetab/docs/sn/ImagensBiometria
mkdir /home/adminetab/docs/sn/Imoveis
mkdir /home/adminetab/docs/sn/ISSQN
mkdir /home/adminetab/docs/sn/LivroCaixa
mkdir /home/adminetab/docs/sn/LivroDeRegistro
mkdir /home/adminetab/docs/sn/Matrimonios
mkdir /home/adminetab/docs/sn/QRCode
mkdir /home/adminetab/docs/sn/Relatorios
mkdir /home/adminetab/docs/sn/Selos
mkdir /home/adminetab/docs/sn/SinalPublico
mkdir /home/adminetab/docs/sn/TextosCorretos
mkdir /home/adminetab/docs/sn/TextosEscrituras
mkdir /home/adminetab/docs/sn/TextosEscriturasImportacao
mkdir /home/adminetab/docs/sn/TransfVeiculos

# Dar permissão nos diretórios 
chmod 777 -R /home/adminetab/system/sn/
chmod 777 -R /home/adminetab/docs/sn/

# Instalar o Samba
apt-get install samba -y

# Add usuário do SO ao Samba 
smbpasswd -a adminetab

# Parar os serviços antes de alterar os arquivos de configuração
systemctl stop smbd.service

# Substituir arquivos de configurações
cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp
mv -f smb.conf /etc/samba/smb.conf

# Iniciar os serviços 
systemctl start smbd.service

# Remover a pasta do projeto 
rm -rf /home/adminetab/etabsistemas/



