#!/bin/bash

# Definir a variável de bucket com o nome do seu bucket
bucket="nome-bucket"

# Criar o arquivo de saída vazio
echo "" > resultado.txt

# Iterar sobre cada arquivo .txt no bucket
for file in $(aws s3 ls s3://$bucket/ --recursive | grep ".txt" | awk '{print $4}'); do
  # Baixar o arquivo .txt para o sistema local
  aws s3 cp s3://$bucket/$file /tmp/$file

  # Adicionar o conteúdo do arquivo .txt ao arquivo de saída
  cat /tmp/$file >> resultado.txt
done

# Fazer o upload do arquivo de saída para o bucket S3
aws s3 cp resultado.txt s3://$bucket/