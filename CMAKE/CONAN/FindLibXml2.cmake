

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindLibXml2.cmake")
# Global approach
set(LibXml2_FOUND 1)
set(LibXml2_VERSION "2.9.10")

find_package_handle_standard_args(LibXml2 REQUIRED_VARS
                                  LibXml2_VERSION VERSION_VAR LibXml2_VERSION)
mark_as_advanced(LibXml2_FOUND LibXml2_VERSION)


set(LibXml2_INCLUDE_DIRS "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include"
			"C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include/libxml2")
set(LibXml2_INCLUDE_DIR "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include;C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include/libxml2")
set(LibXml2_INCLUDES "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include"
			"C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/include/libxml2")
set(LibXml2_RES_DIRS )
set(LibXml2_DEFINITIONS )
set(LibXml2_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(LibXml2_COMPILE_DEFINITIONS )
set(LibXml2_COMPILE_OPTIONS_LIST "" "")
set(LibXml2_COMPILE_OPTIONS_C "")
set(LibXml2_COMPILE_OPTIONS_CXX "")
set(LibXml2_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(LibXml2_LIBRARIES "") # Will be filled later
set(LibXml2_LIBS "") # Same as LibXml2_LIBRARIES
set(LibXml2_SYSTEM_LIBS ws2_32)
set(LibXml2_FRAMEWORK_DIRS )
set(LibXml2_FRAMEWORKS )
set(LibXml2_FRAMEWORKS_FOUND "") # Will be filled later
set(LibXml2_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(LibXml2_FRAMEWORKS_FOUND "${LibXml2_FRAMEWORKS}" "${LibXml2_FRAMEWORK_DIRS}")

mark_as_advanced(LibXml2_INCLUDE_DIRS
                 LibXml2_INCLUDE_DIR
                 LibXml2_INCLUDES
                 LibXml2_DEFINITIONS
                 LibXml2_LINKER_FLAGS_LIST
                 LibXml2_COMPILE_DEFINITIONS
                 LibXml2_COMPILE_OPTIONS_LIST
                 LibXml2_LIBRARIES
                 LibXml2_LIBS
                 LibXml2_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to LibXml2_LIBS and LibXml2_LIBRARY_LIST
set(LibXml2_LIBRARY_LIST libxml2)
set(LibXml2_LIB_DIRS "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_LibXml2_DEPENDENCIES "${LibXml2_FRAMEWORKS_FOUND} ${LibXml2_SYSTEM_LIBS} ZLIB::ZLIB;Iconv::Iconv")

conan_package_library_targets("${LibXml2_LIBRARY_LIST}"  # libraries
                              "${LibXml2_LIB_DIRS}"      # package_libdir
                              "${_LibXml2_DEPENDENCIES}"  # deps
                              LibXml2_LIBRARIES            # out_libraries
                              LibXml2_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "LibXml2")                                      # package_name

set(LibXml2_LIBS ${LibXml2_LIBRARIES})

foreach(_FRAMEWORK ${LibXml2_FRAMEWORKS_FOUND})
    list(APPEND LibXml2_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND LibXml2_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${LibXml2_SYSTEM_LIBS})
    list(APPEND LibXml2_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND LibXml2_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(LibXml2_LIBRARIES_TARGETS "${LibXml2_LIBRARIES_TARGETS};ZLIB::ZLIB;Iconv::Iconv")
set(LibXml2_LIBRARIES "${LibXml2_LIBRARIES};ZLIB::ZLIB;Iconv::Iconv")

set(CMAKE_MODULE_PATH "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/Administrator/.conan/data/libxml2/2.9.10/_/_/package/01aaa5e96f27929fb6bba2fc58f6ed7aff9db697/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${LibXml2_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET LibXml2::LibXml2)
        add_library(LibXml2::LibXml2 INTERFACE IMPORTED)
        if(LibXml2_INCLUDE_DIRS)
            set_target_properties(LibXml2::LibXml2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${LibXml2_INCLUDE_DIRS}")
        endif()
        set_property(TARGET LibXml2::LibXml2 PROPERTY INTERFACE_LINK_LIBRARIES
                     "${LibXml2_LIBRARIES_TARGETS};${LibXml2_LINKER_FLAGS_LIST}")
        set_property(TARGET LibXml2::LibXml2 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${LibXml2_COMPILE_DEFINITIONS})
        set_property(TARGET LibXml2::LibXml2 PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${LibXml2_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT ZLIB_FOUND)
            find_dependency(ZLIB REQUIRED)
        else()
            message(STATUS "Dependency ZLIB already found")
        endif()


        if(NOT Iconv_FOUND)
            find_dependency(Iconv REQUIRED)
        else()
            message(STATUS "Dependency Iconv already found")
        endif()

    endif()
endif()
