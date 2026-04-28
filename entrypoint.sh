#!/bin/bash

UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid)}
SHORT_ID=${SHORT_ID:-$(openssl rand -hex 8)}

KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key" | awk '{print $3}')

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

# Копируем шаблон и заменяем значения через sed (более надёжно)
cp /etc/xray/config.json.template /etc/xray/config.json

sed -i "s|\${UUID}|${UUID}|g" /etc/xray/config.json
sed -i "s|\${SHORT_ID}|${SHORT_ID}|g" /etc/xray/config.json
sed -i "s|\${PRIVATE_KEY}|${PRIVATE_KEY}|g" /etc/xray/config.json
sed -i "s|\${DEST}|${DEST}|g" /etc/xray/config.json
sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|g" /etc/xray/config.json
sed -i "s|\${PORT}|${PORT}|g" /etc/xray/config.json

echo "Конфиг успешно создан с помощью sed. Запускаю Xray..."

exec xray run -c /etc/xray/config.json
