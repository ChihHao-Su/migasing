add_executable(main main.cpp)
add_dependencies(main core)
target_link_libraries(main PRIVATE core)