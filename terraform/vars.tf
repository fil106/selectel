# Selectel token для провайдереа selectel
variable "sel_token" {
  type        = string
  description = "selectel token"
}

# Пул Облачной платформы
variable "region" {
  type    = string
  default = "ru-3"
}

# Значение SSH-ключа для доступа к облачному серверу
variable "public_key" {
  type    = string
  default = "key_value"
}

# Сегмент пула
variable "az_zone" {
  type    = string
  default = "ru-3b"
}

# Тип сетевого диска, из которого создается сервер
variable "volume_type" {
  type    = string
  default = "fast.ru-3b"
}

# CIDR подсети
variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}