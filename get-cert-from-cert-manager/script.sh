#!/bin/bash

#
# THIS FILE IS MANAGED BY ANSIBLE DEPLOYMENT SYSTEM
#

fullchain="/opt/certs/fullchain.pem"
privkey="/opt/certs/privkey.pem"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

update_cert_files() {
    local cert_name="$1"
    local token="$2"
    local cert_id=$(curl -s -H "X-Auth-Token: $token" https://cloud.api.selcloud.ru/certificate-manager/v1/certs | jq -r --arg cert_name "$cert_name" '.[] | select(.name==$cert_name) | .id')

    log "cert-id=$cert_id"

    if [ -z "$cert_id" ]; then
        log "Не удалось найти сертификат с именем $cert_name."
        return 1
    fi

    # Обновляем fullchain.pem
    curl -s \
        -o "$fullchain" \
        -H "X-Auth-Token: $token" \
        https://cloud.api.selcloud.ru/certificate-manager/v1/cert/$cert_id/ca_chain

    # Обновляем privkey.pem
    curl -s \
        -o "$privkey" \
        -H "X-Auth-Token: $token" \
        https://cloud.api.selcloud.ru/certificate-manager/v1/cert/$cert_id/private_key

    log "Файлы сертификата $cert_name обновлены."
}

get_token() {
    local username="$1"
    local password="$2"
    local pj_name="$3"
    local account_id="$4"

    curl -s -i -X POST \
        -H 'Content-Type: application/json' \
        -d "{\"auth\":{\"identity\":{\"methods\":[\"password\"],\"password\":{\"user\":{\"name\":\"$username\",\"domain\":{\"name\":\"$account_id\"},\"password\":\"$password\"}}},\"scope\":{\"project\":{\"name\":\"$pj_name\",\"domain\":{\"name\":\"$account_id\"}}}}}" \
        https://cloud.api.selcloud.ru/identity/v3/auth/tokens | grep x-subject-token | awk '{print $2}'
}

check_cert_expiry() {
    local cert_file="$1"

    if openssl x509 -noout -checkend 2592000 -in "$cert_file"; then
        log "Сертификат $cert_file действителен."
        return 0
    else
        log "Сертификат $cert_file истекает или уже истек."
        return 1
    fi
}

main() {
    if [ ! -f "/opt/certs/credentials.txt" ]; then
        log "Файл /opt/certs/credentials.txt не найден."
        exit 1
    fi

    # Читаем данные из файла credentials.txt
    source "/opt/certs/credentials.txt"

    local token=$(get_token "$username" "$password" "$pj_name" "$account_id")
    log "token=$token"
    if [ -z "$token" ]; then
        log "Не удалось получить токен. Проверьте правильность введенных данных."
        exit 1
    fi

    if ! check_cert_expiry "$fullchain"; then
        log "Срок действия сертификата истекает или уже истек. Необходимо обновить сертификат."
        update_cert_files "$cert_name" "$token"
    else
        log "Сертификат действителен, нет необходимости в обновлении."
    fi
}

# Запуск главной функции
main
