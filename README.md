# ksmb-check
Bash script made for ksmb linux kernel 5.15 vuln check

Este script tem como objetivo verificar qual a versão do kernel linux e se o módulo `kmsbd` está ativo em instancias *AWS*.


## Verificar vulnerabilidade ksmb na AWS
## Requisitos

Para executar o script, é necessário ter:

- Bash
- AWS CLI

## Uso

Para usar o script, basta dar permissão de execução e executá-lo:

```shell
chmod +x aws-ksmb-check.sh 
./aws-ksmb-check.sh
```

O script irá executar os comandos `grep SMB_SERVER /boot/config-$(uname -r)` e `modinfo ksmbd`, armazenar a saída em variáveis e escrever os resultados em um arquivo local chamado `output.txt`. Em seguida, o script fará o upload do arquivo para o bucket S3 especificado na variável `bucket`.

## Personalização

Você pode personalizar o script de acordo com suas necessidades, alterando os comandos que deseja executar e o nome do bucket S3 onde deseja enviar os resultados. Basta alterar os valores da variável `bucket` e dos comandos executados na seção de código correspondente.

## Saída

O arquivo enviado para o bucket S3 terá o seguinte formato:

```text
Hostname: <hostname da máquina local>
<saída do comando grep> 
<saída do comando modinfo>
```

## Colhendo Resultado

O script `aws-ksmb-result.sh`  deve ser executado em uma instância local. Onde ira ler todos os arquivos gerados no *bucket*  e entragar o resultado em um único arquivo `resultado.txt`

```shell
chmod +x aws-ksmb-result.sh
./aws-ksmb-result.sh
```
