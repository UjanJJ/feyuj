#!/bin/bash

# Генерация параметров
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}
SHORT_ID=${SHORT_ID:-$(openssl rand -hex 8)}

# Генерация ключей Reality
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key" | awk '{print $3}')

# Настройки SNI
DEST=${DEST:-"ads.x5.ru:443"}
SERVER_NAME=${SERVER_NAME:-"ads.x5.ru"}

echo "========================================"
echo "VLESS + Reality на Railway"
echo "UUID       : ${UUID}"
echo "Short ID   : ${SHORT_ID}"
echo "Public Key : ${PUBLIC_KEY}"
echo "Dest       : ${DEST}"
echo "SNI        : ${SERVER_NAME}"
echo "Порт       : ${PORT}"
echo "========================================"

# Создаём конфиг из шаблона
envsubst < /etc/xray/config.json.template > /etc/xray/config.json

echo "Конфиг создан успешно. Запускаю Xray..."

exec xray run -c /etc/xray/config.json
