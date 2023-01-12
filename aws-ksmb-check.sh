#!/bin/bash

# Definir a variável de bucket com o nome do seu bucket
bucket="nome-bucket"

# Obter hostname da máquina local
hostname=$(hostname)

# Executar comandos e armazenar saída em variáveis
grep_output=$(grep SMB_SERVER /boot/config-$(uname -r))
modinfo_output=$(modinfo ksmbd)

# Escrever a saída em um arquivo .txt local
echo "Hostname: $hostname" > output.txt
echo "$grep_output" >> output.txt
echo "$modinfo_output" >> output.txt

# Fazer o upload do arquivo .txt para o bucket S3
aws s3 cp output.txt s3://$bucket/$hostname.txt