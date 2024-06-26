# Скрипт для управления сертификатами

Этот скрипт предназначен для автоматического обновления сертификатов с помощью API сервиса управления сертификатами.

## Описание

Скрипт выполняет следующие действия:

- Получает токен аутентификации по данным из файла `credentials.txt`.
- Проверяет срок действия сертификата.
- Если сертификат истекает или истек, обновляет его, используя полученный токен.

## Требования

Для работы скрипта требуется установленная утилита `jq` для обработки JSON.

## Использование

1. Создайте файл `credentials.txt` в формате:

```txt
username=<имя сервисного пользователя>
password=<пароль от сервисного пользователя>
pj_name=<имя проекта>
account_id=<ID Selectel account>
cert_name=<имя сертификата в менеджере секретов>
```


2. Убедитесь, что у скрипта есть права на выполнение:

```bash
chmod +x update_certs.sh
```

