cmake_minimum_required(VERSION 3.5)
project(hello-cmake)

add_executable(hello-cmake main.cpp)
install(TARGETS hello-cmake RUNTIME DESTINATION bin)
