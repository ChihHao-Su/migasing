add_library(ui module.cpp)
add_dependencies(ui core)
target_link_libraries(ui core)
target_include_directories(ui PRIVATE ${CMAKE_CURRENT_BINARY_DIR})