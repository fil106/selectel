# Пул Облачной платформы
variable "region" {
  type    = string
  default = "ru-3"
}

# Сегмент пула
variable "az_zone" {
  type    = string
  default = "ru-3b"
}

variable "router_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

# Тип сетевого диска, из которого создается сервер
variable "volume_type" {
  type    = string
  default = "fast"
}

# Объём диска для вм
variable "volume_size" {
  type    = string
  default = "5"
}

# CIDR подсети
variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}

# Кол-во инсталляций
variable "vm_name" {
  type = string
}

# Какой хотим образ для вм
variable "image_name" {
  type = string
}

# Имя flavor для вм
variable "flavor_name" {
  type = string
}