FROM alpine:latest

RUN apk add --no-cache \
    curl \
    unzip \
    bash \
    ca-certificates \
    openssl \
    gettext          # ← Вот это главное! Добавили gettext для envsubst

# Скачиваем Xray
ARG XRAY_VERSION=1.8.23
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

RUN mkdir -p /etc/xray /var/log/xray

WORKDIR /etc/xray

COPY config.json.template /etc/xray/config.json.template
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
