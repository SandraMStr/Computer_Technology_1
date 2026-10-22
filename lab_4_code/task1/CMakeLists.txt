cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)

project(lab4_task1 C CXX ASM)
set(CMAKE_C_STANDARD 11)
pico_sdk_init()

foreach(t task1a task1b task1c)
    add_executable(${t} ${t}.c)
    target_link_libraries(${t} pico_stdlib)
    pico_enable_stdio_usb(${t} 1)
    pico_enable_stdio_uart(${t} 0)
    pico_add_extra_outputs(${t})
endforeach()
