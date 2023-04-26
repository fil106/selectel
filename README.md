# Запуск виртуалок в selectel

Существует 2 способа запуска виртуалок 
1) Terraform
2) Openstack cli

## Запуск terraform

**ВАЖНО! получение провайдеров заблокировано из России, нужен vpn. Или скачать вручную и положить в папку `terraform.d`**

### Через terraform cli

Необходимо установить `terraform-cli` - [офф. дока](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- переходим в директорию `terraform`
- выполняем `terraform init`
- выполняем `terraform plan`
  - вставляем selectel api key - https://my.selectel.ru/profile/apikeys
- выполняем `terraform apply`
  - вставляем selectel api key - https://my.selectel.ru/profile/apikeys
  - подтверждаем свои намерения вводим `yes`

### Из `Docker`

Используем образ [hashicorp/terraform:1.4.5](https://hub.docker.com/layers/hashicorp/terraform/1.4.5/images/sha256-1f64a3e43ed16ea1f98253813634168b2fff64c81704112f2fabda7835a226f7?context=explore)

**ВАЖНО! При запуске из Docker необходимо сохранить state-файл иначе при каждом прогоне будут заново создавать виртуалки**

- переходим в директорию `terraform`
- `docker run -it -v $(pwd):/terraform hashicorp/terraform:1.4.5 -chdir=terraform init`
- `docker run -it -v $(pwd):/terraform hashicorp/terraform:1.4.5 -chdir=terraform plan`
  - вставляем selectel api key - https://my.selectel.ru/profile/apikeys
- `docker run -it -v $(pwd):/terraform hashicorp/terraform:1.4.5 -chdir=terraform apply`
  - вставляем selectel api key - https://my.selectel.ru/profile/apikeys
  - подтверждаем свои намерения вводим `yes`
