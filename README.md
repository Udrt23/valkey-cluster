# Building and maintaining a Valkey cluster

## Building the RediSearch module ##
Cloning the GitHub repository, at the time of creating the cluster, the module version was 2.8.14
> git clone --recursive https://github.com/RediSearch/RediSearch.git

Installing dependencies
> ./sbin/setup

Installing the Boost library set
> cd .install && ./install_boost.sh 1.83.0

Building the module via make for the cluster (RediSearch Coordinator)
> cd .. && make -j$(nproc) COORD=1

## Building the RedisJSON module ##
Cloning the GitHub repository, at the time of creating the cluster, the module version was 2.6.10
> git clone https://github.com/RedisJSON/RedisJSON.git

Installing curl, clang
> apt install curl clang

Installing Rust
> curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

Update shell session
> source "$HOME/.cargo/env"

Build module in release mode
> cargo build --release

Add execution bit
> chmod u+x target/release/librejson.so

## Build Valkey database ##
Cloning GitHub repository, at the time of cluster creation database version 7.2.5
> git clone --recursive https://github.com/valkey-io/valkey.git

Installing packages required for build
> apt install git make build-essential pkg-config libjemalloc2 libsystemd-dev nasm autotools-dev autoconf libhiredis-dev libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev git libssl-dev dpkg-dev pkg-config ca-certificates libbz2-dev libzstd-dev liblz4-dev

Build with TLS, systemd and flash support
> make -j$(nproc) BUILD_TLS=yes USE_SYSTEMD=yes ENABLE_FLASH=yes

Run tests to check the correctness of the build
> make -j$(nproc) test

Configure memory allocation
> sysctl -w vm.overcommit_memory=1

Disable the transparent hugepages page in the kernel
> echo never > /sys/kernel/mm/transparent_hugepage/enabled
