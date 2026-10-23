cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)
project(Average C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

include_directories(${CMAKE_SOURCE_DIR})

add_executable(Average
  Average.S
)

pico_enable_stdio_uart(Average 0)
pico_enable_stdio_usb(Average 1)

pico_add_extra_outputs(Average)

target_link_libraries(Average pico_stdlib)
