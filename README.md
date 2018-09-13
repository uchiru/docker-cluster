# Docker Cluster Tutorial

Поднимаем докер-кластер с использованием инструментов HashiCorp, Казань 2018

## Step by Step Guide

https://kb.selectel.ru/22060499.html - база знаний облака Селектела.

### Подготовка

1. Склонируйте данный репозитарий

1. Зарегистрируйте аккаунт в Селектеле/используйте готовый если есть. https://my.selectel.ru/ -> Зарегистрироваться -> Почта, Подтверждение, СМС, PROFIT!

1. Пополните баланс аккаунта/активируйте промокод, чтобы появились деньги на аккаунте приватного облака

1. Заведите новый проект на странице приватного облака - https://my.selectel.ru/vpc/projects

1. Добавьте публичную подсеть в регионе ru-1b, для этого нужно нажать раскрыть панель "Санкт-Петербург" и на вкладке "Ресурсы Дубровка-2 (ru-1b)" нажать кнопку "Добавить Публичную Подсеть"

1. Добавьте нового пользователя, на странице пользователей https://my.selectel.ru/vpc/users

1. Пользователя добавьте в проект, а таже прикрепите к пользователю свой ssh-ключ.

1. Скачайте файл `rc.sh` с настройками OpenStack API со страницы https://my.selectel.ru/vpc/access и положите его в корень данного репозитария

1. В файле `rc.sh` замените

```
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
```

на

```
export OS_PASSWORD=<пароль пользователя, прикрепленного к проекту>
export TF_VAR_KEY_PAIR=<имя ssh-ключа>
export TF_VAR_network01_id=<UUID публичной сети проекта>
export TF_VAR_main01_public_ip=<внешний IP-адрес главного сервера из публичной сети>
export TF_VAR_ACCOUNT_ID=$OS_PROJECT_DOMAIN_NAME
export TF_VAR_PASSWORD=$OS_PASSWORD
export TF_VAR_PROJ_ID=$OS_PROJECT_ID
export TF_VAR_USER=$OS_USERNAME
```

**Note:** из публичной сети `\29` доступно 5 адресов, самая простая мнемоника, если вам выдали сеть `5.189.236.216/29`, то первый адрес `CIDR + 2`, то есть `5.189.236.218`

10. Запустите докер контейнер с нужными утилитами с помощью команды:

```
docker build -t ostack ostack && docker run -it \
  -w /w \
  -v `pwd`:/w \
  ostack bash
```

11. Выполните в контейнере команду `source rc.sh`


### Терраформим сервера

1. Создайте сервера

```
cd terraform
terraform init
terraform plan
terraform apply
cd ..
```
