## Запуск виртуалок в selectel

Существует 2 способа запуска виртуалок 
1) Terraform
2) Openstack cli

В папке `terraform` собран пример запуска n количества виртуальных машин.
- Для запуска необходимо передать selectel token из панели https://my.selectel.ru/profile/apikeys
- Стейт хранится локально
- После выполнения будет доступен файл vars.tfvars в котором будут vm_fip=password
