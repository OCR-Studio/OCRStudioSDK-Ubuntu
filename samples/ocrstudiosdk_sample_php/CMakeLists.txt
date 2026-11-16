cmake_minimum_required(VERSION 3.12)
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

project(phpocrstudiosdk)

find_library(LIBRARY_NAME ocrstudiosdk HINTS ${OCRSTUDIOSDK_LIBRARY_PATH})

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../include)

execute_process(COMMAND ${PHP_CONFIG_PATH} --includes
  OUTPUT_VARIABLE PHP_INCLUDE_DIRS
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(COMMAND ${PHP_CONFIG_PATH} --php-binary
  OUTPUT_VARIABLE PHP_EXECUTABLE
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "variable is:  ${PHP_CONFIG_PATH}")

execute_process(COMMAND ${PHP_CONFIG_PATH} --version
  OUTPUT_VARIABLE PHP_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "variable is:  ${PHP_VERSION}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpermissive -std=c++11 ${PHP_INCLUDE_DIRS}")
set(CMAKE_BUILD_TYPE "debug")

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

set(MY_SWIG_FILE phpocrstudiosdk.i)
set_property(SOURCE ${MY_SWIG_FILE} PROPERTY CPLUSPLUS ON INCLUDE_DIRECTORIES ../../include)

SWIG_ADD_MODULE(phpocrstudiosdk php7 ${MY_SWIG_FILE})

set_target_properties(${SWIG_MODULE_phpocrstudiosdk_REAL_NAME} PROPERTIES PREFIX "")

set_property(TARGET phpocrstudiosdk PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES TRUE)

set_property(TARGET phpocrstudiosdk PROPERTY GENERATED_COMPILE_OPTIONS "-fPIC")

set_property(TARGET phpocrstudiosdk PROPERTY LINK_OPTIONS "-Wl,--enable-new-dtags")

target_link_libraries(phpocrstudiosdk ${LIBRARY_NAME})
SWIG_LINK_LIBRARIES(phpocrstudiosdk ${LIBRARY_NAME})

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../../")
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/bin")

install(TARGETS phpocrstudiosdk
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION bin
)

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,--enable-new-dtags")
