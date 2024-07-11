# Сборка и обслуживание кластера Valkey

## Сборка модуля RediSearch ##
Клонирование репозитория GitHub, на момент создания кластера версия модуля 2.8.14
> git clone --recursive https://github.com/RediSearch/RediSearch.git


Установка зависимостей
> ./sbin/setup


Установка набора библиотек Boost
> cd .install && ./install_boost.sh 1.83.0

Сборка модуля через make для кластера (RediSearch Coordinator)
> cd .. && make -j$(nproc) COORD=1


## Сборка модуля RedisJSON ##
Клонирование репозитория GitHub, на момент создания кластера версия модуля 2.6.10
> git clone https://github.com/RedisJSON/RedisJSON.git

Установка curl, clang
> apt install curl clang

Установка Rust
> curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

Обновление shell-сессии
> source "$HOME/.cargo/env"

Сборка модуля в режиме release
> cargo build --release

Добавление бита исполнения
> chmod u+x target/release/librejson.so


## Сборка базы данных Valkey ##
Клонирование репозитория GitHub, на момент создания кластера версия базы данных 7.2.5
> git clone --recursive https://github.com/valkey-io/valkey.git

Установка необходимых для сборки пакетов
> apt install git make build-essential pkg-config libjemalloc2 libsystemd-dev nasm autotools-dev autoconf libhiredis-dev libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev git libssl-dev dpkg-dev pkg-config ca-certificates libbz2-dev libzstd-dev liblz4-dev

Сборка с поддержкой TLS, systemd и flash
> make -j$(nproc) BUILD_TLS=yes USE_SYSTEMD=yes ENABLE_FLASH=yes

Запуск тестов, для проверки правильности сборки
> make -j$(nproc) test

Настройка распределения памяти
> sysctl -w vm.overcommit_memory=1

Отключение прозрачной страницы hugepages в ядре
> echo never > /sys/kernel/mm/transparent_hugepage/enabled
