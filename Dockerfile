# Базовый образ для сборки
FROM ubuntu:22.04 AS builder

# Установка минимальных зависимостей для сборки
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    ca-certificates \
    curl \
    tar \
    zip \
    unzip \
    pkg-config \
    gzip && \
    rm -rf /var/lib/apt/lists/*

# Клонирование и настройка vcpkg
RUN git clone https://github.com/Microsoft/vcpkg.git && \
    cd vcpkg && \
    ./bootstrap-vcpkg.sh

# Копирование проекта
WORKDIR /app
COPY . .

# Сборка зависимостей и проекта
RUN cd /vcpkg && ./vcpkg install drogon jsoncpp  # Используем абсолютный путь

RUN mkdir -p build && \
    cd build && \
    cmake -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake .. && \
    make

# Финальный образ
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libjsoncpp25 \
    libuuid1 \
    libssl3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/cpp-hostname-k8s /app/
CMD ["/app/cpp-hostname-k8s"]
