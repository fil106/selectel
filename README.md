# Запуск виртуалок в selectel

Существует 2 способа запуска виртуалок 
1) Terraform
2) Openstack cli

## Запуск terraform

**ВАЖНО! получение провайдеров заблокировано из России, нужен vpn. Или скачать вручную и положить в папку `terraform.d`. Существуют также и другие способы, например приватный registry для провайдеров**

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

## Openstack CLI

1) Устанавливаем [инструкция](https://docs.selectel.ru/cloud/servers/tools/openstack/)
2) Для того чтобы openstack cli знал в какую api идти необходимо
   3) либо сделать source файла rc.sh из панели, но прежде должен быть создан проект - [как получить rc.sh](https://docs.selectel.ru/cloud/serverless/instructions/set-up-autodeploy/#получение-rc-файла)
   4) либо вфполнить export нужных ENV переменных для openstack cli [создание и source rc.sh](https://docs.openstack.org/newton/user-guide/common/cli-set-environment-variables-using-openstack-rc.html)
3) Выбор региона куда ходить openstack cli определяется через переменную `OS_REGION_NAME=ru-9`

### Как узнать доступные конфигурации (flavors)

Чтобы вывести весь список конфигураций в определенном регионе можно выполнить данную команду

```bash
#: openstack flavor list --public --long -f value -c ID -c Name -c Properties

3031 GL3.4-32768-0-1GPU {'aggregate_instance_extra_specs:gpu': 'T4', 'hw:cpu_max_sockets': '2', 'hw:hide_hypervisor_id': 'true', 'pci_passthrough:alias': 'T4:1'}
```

В результате мы получим вывод с ID, name и properties колонками. Отсюда мы можем понять какое имя flavor с какой видеокартой матчится