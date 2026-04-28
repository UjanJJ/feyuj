#!/bin/bash

UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}
SHORT_ID=${SHORT_ID:-$(openssl rand -hex 8)}

# Генерация ключей Reality
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key" | awk '{print $3}')

# Выбираем dest и serverName
DEST=${DEST:-"ads.x5.ru:443"}
SERVER_NAME=${SERVER_NAME:-"ads.x5.ru"}

echo "========================================"
echo "VLESS + Reality запущен на Railway"
echo "UUID       : ${UUID}"
echo "Short ID   : ${SHORT_ID}"
echo "Public Key : ${PUBLIC_KEY}"
echo "Dest       : ${DEST}"
echo "SNI        : ${SERVER_NAME}"
echo "Порт       : ${PORT}"
echo "========================================"

# Подставляем переменные
envsubst < /etc/xray/config.json.template > /etc/xray/config.json

exec xray run -c /etc/xray/config.json
