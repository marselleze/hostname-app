cmake_minimum_required(VERSION 3.5)
project(cpp-hostname-k8s)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Добавляем текущую директорию в include пути
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

find_package(Drogon CONFIG REQUIRED)
find_package(jsoncpp CONFIG REQUIRED)

# Основной исполняемый файл
add_executable(${PROJECT_NAME}
    main.cpp
    handler.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Drogon::Drogon
    JsonCpp::JsonCpp
)

# Тесты
enable_testing()

find_package(GTest REQUIRED)

# Тестовый таргет
add_executable(tests
    tests/handler_test.cpp
    handler.cpp  # Важно добавить реализацию
)

target_link_libraries(tests PRIVATE
    GTest::gtest_main
    Drogon::Drogon
    JsonCpp::JsonCpp
)

add_test(NAME HostnameTests COMMAND tests)
