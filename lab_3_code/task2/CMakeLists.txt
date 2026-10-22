cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)

project(lab3_task2 C CXX ASM)
set(CMAKE_C_STANDARD 11)
pico_sdk_init()

add_executable(task2 main.S sdklink.c)
target_link_libraries(task2 pico_stdlib)

pico_enable_stdio_usb(task2 1)
pico_enable_stdio_uart(task2 0)

pico_add_extra_outputs(task2)
