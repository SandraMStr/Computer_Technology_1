cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)

project(lab3_task3 C CXX ASM)
set(CMAKE_C_STANDARD 11)
pico_sdk_init()

add_executable(task3 main.S sdklink.c)
target_link_libraries(task3 pico_stdlib)

pico_enable_stdio_usb(task3 1)
pico_enable_stdio_uart(task3 0)

pico_add_extra_outputs(task3)
