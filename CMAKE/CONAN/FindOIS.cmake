

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

conan_message(STATUS "Conan: Using autogenerated FindOIS.cmake")
# Global approach
set(OIS_FOUND 1)
set(OIS_VERSION "1.5")

find_package_handle_standard_args(OIS REQUIRED_VARS
                                  OIS_VERSION VERSION_VAR OIS_VERSION)
mark_as_advanced(OIS_FOUND OIS_VERSION)


set(OIS_INCLUDE_DIRS "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/include")
set(OIS_INCLUDE_DIR "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/include")
set(OIS_INCLUDES "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/include")
set(OIS_RES_DIRS )
set(OIS_DEFINITIONS "-DOIS_WIN32_XINPUT_SUPPORT"
			"-DOIS_DYNAMIC_LIB")
set(OIS_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(OIS_COMPILE_DEFINITIONS "OIS_WIN32_XINPUT_SUPPORT"
			"OIS_DYNAMIC_LIB")
set(OIS_COMPILE_OPTIONS_LIST "" "")
set(OIS_COMPILE_OPTIONS_C "")
set(OIS_COMPILE_OPTIONS_CXX "")
set(OIS_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(OIS_LIBRARIES "") # Will be filled later
set(OIS_LIBS "") # Same as OIS_LIBRARIES
set(OIS_SYSTEM_LIBS dinput8 dxguid)
set(OIS_FRAMEWORK_DIRS )
set(OIS_FRAMEWORKS )
set(OIS_FRAMEWORKS_FOUND "") # Will be filled later
set(OIS_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(OIS_FRAMEWORKS_FOUND "${OIS_FRAMEWORKS}" "${OIS_FRAMEWORK_DIRS}")

mark_as_advanced(OIS_INCLUDE_DIRS
                 OIS_INCLUDE_DIR
                 OIS_INCLUDES
                 OIS_DEFINITIONS
                 OIS_LINKER_FLAGS_LIST
                 OIS_COMPILE_DEFINITIONS
                 OIS_COMPILE_OPTIONS_LIST
                 OIS_LIBRARIES
                 OIS_LIBS
                 OIS_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to OIS_LIBS and OIS_LIBRARY_LIST
set(OIS_LIBRARY_LIST OIS)
set(OIS_LIB_DIRS "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_OIS_DEPENDENCIES "${OIS_FRAMEWORKS_FOUND} ${OIS_SYSTEM_LIBS} ")

conan_package_library_targets("${OIS_LIBRARY_LIST}"  # libraries
                              "${OIS_LIB_DIRS}"      # package_libdir
                              "${_OIS_DEPENDENCIES}"  # deps
                              OIS_LIBRARIES            # out_libraries
                              OIS_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "OIS")                                      # package_name

set(OIS_LIBS ${OIS_LIBRARIES})

foreach(_FRAMEWORK ${OIS_FRAMEWORKS_FOUND})
    list(APPEND OIS_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND OIS_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${OIS_SYSTEM_LIBS})
    list(APPEND OIS_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND OIS_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(OIS_LIBRARIES_TARGETS "${OIS_LIBRARIES_TARGETS};")
set(OIS_LIBRARIES "${OIS_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/Administrator/.conan/data/ois/1.5/_/_/package/127af201a4cdf8111e2e08540525c245c9b3b99e/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${OIS_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET OIS::OIS)
        add_library(OIS::OIS INTERFACE IMPORTED)
        if(OIS_INCLUDE_DIRS)
            set_target_properties(OIS::OIS PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${OIS_INCLUDE_DIRS}")
        endif()
        set_property(TARGET OIS::OIS PROPERTY INTERFACE_LINK_LIBRARIES
                     "${OIS_LIBRARIES_TARGETS};${OIS_LINKER_FLAGS_LIST}")
        set_property(TARGET OIS::OIS PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${OIS_COMPILE_DEFINITIONS})
        set_property(TARGET OIS::OIS PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${OIS_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()