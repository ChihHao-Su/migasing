cmake_minimum_required(VERSION 3.19)
project(MigaSing)
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/SRC)
set(THIRDPARTY_DIE ${CMAKE_CURRENT_SOURCE_DIR}/TGUI-0.9)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/CONAN)
add_subdirectory(SRC/core)
add_subdirectory(SRC/main)
add_subdirectory(SRC/ui)
#add_subdirectory(SRC/singengine)

if(SELF_BUILD_DEPS)
    include(ExternalProject)
    ExternalProject_Add(CEGUI 
        URL "https://sourceforge.net/projects/crayzedsgui/files/latest/download"
        URL_HASH MD5=0cf9f2df4c5345187c8e4c49888242d9
        CMAKE_ARGS -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/CONAN
                    -DCEGUI_SAMPLES_ENABLED:BOOL=OFF
        PATCH_COMMAND patch < THIRDPARTY/CEGUI/patch.patch
    )
endif(SELF_BUILD_DEPS)