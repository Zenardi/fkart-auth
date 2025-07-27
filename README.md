# FKART Auth com Keycloak

Este repositório contém a configuração para implantar uma instância do Keycloak no Heroku usando Docker.

A criação e configuração da aplicação no Heroku são automatizadas através de um pipeline do GitHub Actions.

## Pré-requisitos

Antes de executar o pipeline, você precisa configurar os seguintes "Secrets" no seu repositório do GitHub (`Settings` > `Secrets and variables` > `Actions`):

1.  `HEROKU_API_KEY`: Sua chave de API do Heroku. Você pode encontrá-la no Dashboard da sua conta Heroku.
2.  `KEYCLOAK_ADMIN_PASSWORD`: A senha que você deseja para o usuário `admin` do Keycloak. Escolha uma senha forte.

## Como Fazer o Deploy

O processo de criação da infraestrutura no Heroku é totalmente automatizado.

1.  **Execute o Pipeline de Provisionamento:**
    *   Vá para a aba **"Actions"** do seu repositório no GitHub.
    *   Na barra lateral esquerda, selecione o workflow **"Provision Heroku App"**.
    *   Clique em **"Run workflow"**. O pipeline irá criar a aplicação no Heroku, adicionar o banco de dados e configurar todas as variáveis de ambiente necessárias.

2.  **Conecte o Repositório para Deploys Automáticos:**
    *   Após o pipeline ser concluído com sucesso, acesse o Dashboard do Heroku.
    *   Selecione a aplicação `fkart-auth`.
    *   Vá para a aba **"Deploy"**.
    *   Em "Deployment method", clique em **"GitHub"**, autorize o acesso e conecte este repositório.
    *   Habilite **"Automatic Deploys"** para o branch `main`.

3.  **Inicie o Primeiro Deploy:**
    *   Qualquer `push` subsequente para o branch `main` irá automaticamente construir a imagem do Keycloak e implantá-la no Heroku. Para iniciar o primeiro deploy, você pode fazer um push vazio:
      ```shell
      git commit --allow-empty -m "Trigger initial deploy"
      git push origin main
      ```

## Verificando a Aplicação

Após o deploy ser concluído, você pode monitorar os logs e abrir a aplicação com os comandos do Heroku CLI:

```shell
heroku logs --tail -a fkart-auth
heroku open -a fkart-auth
```

Se tudo correu bem, você verá a página de boas-vindas do Keycloak. Você pode acessar o console de administração em /admin e fazer login com o usuário e senha que definiu nas variáveis de ambiente.

## Upgrade no Postgres
Para fazer o upgrade do plano do postgres execute o comando
```shell
heroku addons:upgrade heroku-postgresql:basic -a fkart-auth
```

# Considerações Importantes
- Custo: Esta configuração não se enquadra no plano gratuito do Heroku. Você precisará de, no mínimo, um dyno Basic (para evitar que a aplicação "durma") e o add-on heroku-postgresql:basic.
- HTTPS: O Heroku gerencia o certificado SSL para você, então sua instância do Keycloak já estará acessível via HTTPS, o que é um requisito de segurança. A configuração KC_PROXY=edge informa ao Keycloak que ele está atrás de um proxy reverso (o roteador do Heroku), o que é essencial para ele gerar as URLs corretas.
- Performance: O primeiro boot do Keycloak pode ser um pouco lento. Monitore os logs para garantir que ele inicie sem erros. Dependendo da sua carga de trabalho, você pode precisar de um plano de dyno e de banco de dados mais robusto.