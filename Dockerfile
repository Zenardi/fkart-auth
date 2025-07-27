# Use uma versão recente e estável do Keycloak
FROM quay.io/keycloak/keycloak:26.3 as builder

# Ambiente de produção
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange

# Otimiza o Keycloak para produção com o provider de banco de dados PostgreSQL
# Este passo é importante para a performance e estabilidade
RUN /opt/keycloak/bin/kc.sh build --db=postgres

# A imagem final será menor e mais limpa
FROM quay.io/keycloak/keycloak:26.3
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Expõe a porta que o Keycloak usa
EXPOSE 8080

# Define o comando para iniciar o Keycloak em modo produção
# As configurações serão injetadas via variáveis de ambiente pelo Heroku
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
