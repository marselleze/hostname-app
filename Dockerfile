# Сборка
FROM ubuntu:22.04 AS builder

# Установка базовых зависимостей
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    build-essential \
    cmake \
    pkg-config \
    tar \
    zip \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Установка vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git
WORKDIR /vcpkg
RUN ./bootstrap-vcpkg.sh

# Установка зависимостей
RUN ./vcpkg install \
    drogon[core] \
    jsoncpp \
    --triplet x64-linux

# Копирование проекта с исправленным CMakeLists.txt
WORKDIR /app
COPY . .

# Сборка проекта
RUN mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake .. && \
    make -j$(nproc)

# Финальный образ
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y \
    libjsoncpp25 \
    libuuid1 \
    libssl3 \
    zlib1g \
    libc-ares2 \
    libbrotli1 \
    libzstd1 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/cpp-hostname-k8s .
CMD ["./cpp-hostname-k8s"]
