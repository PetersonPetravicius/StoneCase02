# ApiAutomationStoneCase2
Desafio de automação de API da StoneCO

## 🚀 Começando 🚀 

Essas instruções permitirão que você obtenha uma cópia do projeto em operação na sua máquina local para fins de desenvolvimento e teste.

Consulte **[Implantação](https://github.com/PetersonPetravicius/StoneCase02/blob/main/README.md)** para saber como implantar o projeto.

### 📋 Pré-requisitos 📋


+ [Python v3.12.4 ++](https://www.python.org/downloads/) 

+ [GitBash 2.44.0 ++](https://git-scm.com/downloads)

+ IDE [VScode](https://code.visualstudio.com/download)


```

Realizar a instalação dos programas antes de dar inicio ao clone do projeto.
OBS: Quando Instalar o python, selecionar a opção "Add python,exe TO PATH para não precisar configurar manualmente as variaveis de ambiente

```

### 🔧 Instalação 🔧

Ao atender os pré-requisitos, é necesario configurar o [gitBash](https://git-scm.com/book/pt-br/v2/Come%C3%A7ando-Configura%C3%A7%C3%A3o-Inicial-do-Git).

```
Seguir o artigo de configuração GITBASH.

```

Feito isto, você está apto a realizar o [Clone](https://www.dio.me/articles/comando-git-conheca-o-git-clone-como-nunca) do projeto

```

Seguir o artigo detalhado para realizar o Clone deste projeto em sua maquina local.

```


🏆Se chegou até aqui, então o projeto ja está disponivel para analise e execução dos testes no seu local.🏆 


## ⚙️ Executando os testes ⚙️ 

Para execução dos testes devemos executar no terminal do VS Code ou gitbash a instalação do robotframework e suas bibliotecas
```

Passo 01: No terminal VS Code ou GitBash (na pasta principal do projeto) rodar o comando
'pip install robotframework' para instalação do framework
Passo 02: Após execução do comando acima, envie o comando 'pip install robotframework requests' baixa a Library requests utilizada
na automação deste Case
PASSO 03: Para verificar se as intalações correram bem, envie o comando 'pip list' e busque no resultado a biblioteca mencionada no passo 02
PASSO 04: Execute os testes enviando o comando 'python run_tests.py' a partir da pasta principal do projeto

```
### 🔩 Analise os testes de ponta a ponta 🔩

Ao fim da execução dos testes, um pequeno report com o resumo das execuções será exibido na guia "Terminal" quando executado o comando do PASSO 04.

```
C:\Users\Peterson Petravicius\AppData\Local\Programs\Python\Python312\Lib\site-packages\urllib3\connectionpool.py:1103: InsecureRequestWarning: Unverified HTTPS request is being made to host 'sandbox-api.openbank.stone.com.br'. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.io/en/latest/advanced-usage.html#tls-warnings
  warnings.warn(
| PASS |
------------------------------------------------------------------------------
Tests.Api Testing Openbank                                            | FAIL |
12 tests, 9 passed, 3 failed
==============================================================================
Tests                                                                 | FAIL |
16 tests, 13 passed, 3 failed
==============================================================================
Output:  C:\CasesStoneCO\StoneCase02\result\result_20240608_203315\output.xml
Log:     C:\CasesStoneCO\StoneCase02\result\result_20240608_203315\log.html
Report:  C:\CasesStoneCO\StoneCase02\result\result_20240608_203315\report.html
```

Uma pasta "Results" será gerada na raiz do projeto contendo o arquivo "log.html" desta execução, possuindo maiores detalhes em forma de report.

![image](https://github.com/PetersonPetravicius/StoneCase02/assets/25805686/19ad5750-b45b-47e4-a00e-dc8fc9a13fc3)


## 📑 ANALISE DO CASE 📑
```

### Cenário

A Stone possui uma API de [OpenBanking](https://en.wikipedia.org/wiki/Open_banking) que estamos testando e evoluindo continuamente. O link para a documentação de referência é https://docs.openbank.stone.com.br/. 

Queremos que você use esta API para nos mostrar como iria automatizar as várias formas de se inferir qualidade das entregas.

Por exemplo: temos um endpoint para simular uma transação interna em `api/v1/dry_run/internal_transfers`. Queremos que você proponha uma solução de automação neste ambiente de "sandbox" da API. 

Espera-se que você faça a automação de 3 endpoints:

- Saldo: `GET api/v1/accounts/:id/balance`
- Extrato: `GET api/v1/accounts/:id/statement`
- Simulação de transferência interna: `POST api/v1/dry_run/internal_transfers`

Os dados para acesso serão detalhados mais abaixo.

### Como operar na API de sandbox da Stone OpenBanking?

Todos os endpoints possuem autenticação. Utilizamos OAuth2 e OpenID Connect como especificações de autenticação e autorização. Para o desafio de QA, criamos uma "client application" e um usuário para os testes:

- client_id: XXXXXXXXXX
- username: YYYYYYYY
- password: ZZZZZZZZ

Para conseguir o token de acesso, basta fazer um POST para o nosso IAM:


curl https://login.sandbox.stone.com.br/auth/realms/stone_account/protocol/openid-connect/token \
	  -d 'client_id=XXXXXXXXXX' \
	  -d 'username=YYYYYYYYY' \
	  -d 'password=ZZZZZZZZZ' \
          -d 'grant_type=password'

### Informações sobre a etapa

   - Utilizar o formato Gherkin para a descrever os casos;
   - Os casos de testes devem ser construídos através do Robot Framework;
   - O desafio deve conter, no mínimo, um projeto de código que instrumente o uso da API seguindo um conjunto de cenários que você mesmo irá criar para os 3 endpoints citados acima;
   - A execução deve retornar um status;
   - Ao término da execução deve ser gerado um relatório sobre as APIs testadas (cenários com sucesso/falha, timing, security e etc);
   - As instruções para executar o projeto devem estar no README na pasta raiz do repositório.

```
