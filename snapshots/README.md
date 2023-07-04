## Скрипт создания снэпшота и диска из него

1. Необходимо получить файл rc.sh из панели управления проектом→доступ
2. Добавить property в сетевой диск который хотим бэкапить
   ```sh
   openstack volume set --property autoSnapshot=true <volume uuid>
   ```
3. Выставить свои параметры
   ```sh
   retentionDays=5
   region="ru-9a"
   ```
4. Запустить скрипт
   ```sh
   bash autosnapshot.sh rc.sh
   ```
