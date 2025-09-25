cmake_minimum_required(VERSION 3.12)

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

PROJECT (csocrstudiosdk)

# Include headers
include_directories(./../../include/)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../include)

# Find and setup SWIG
find_library(LIBRARY_NAME ocrstudiosdk HINTS ${OCRSTUDIOSDK_LIBRARY_PATH})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpermissive -std=c++11")
find_package(SWIG 4.1.1 EXACT REQUIRED)
INCLUDE(${SWIG_USE_FILE})


# SWIG module in CMake does not know that dll library on Windows platform is RUNTIME target.
# As the result, CMake puts library into wrong directory. Here is a fix for this issue.
IF(WIN32)
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}")
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}")
ENDIF(WIN32)

SET(MY_SWIG_FILE csocrstudiosdk.i)


# Generate CS sources
SET_SOURCE_FILES_PROPERTIES(${MY_SWIG_FILE} PROPERTIES CPLUSPLUS ON)
# Set the CS namespace
LIST(APPEND my_options -namespace ocrstudio)

SET_SOURCE_FILES_PROPERTIES(${MY_SWIG_FILE} PROPERTIES SWIG_FLAGS "${my_options}")

SWIG_ADD_MODULE(csocrstudiosdk csharp ${MY_SWIG_FILE})

TARGET_LINK_LIBRARIES(csocrstudiosdk ${LIBRARY_NAME})
SWIG_LINK_LIBRARIES(csocrstudiosdk ${LIBRARY_NAME})

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../../")
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/bin")

# Install the csharp lib
INSTALL(TARGETS csocrstudiosdk
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION bin)

# Install all Python files in /bindings/csharp dir
INSTALL(
  CODE "FILE(GLOB cs_files \"${CMAKE_CURRENT_BINARY_DIR}/*.cs\")"
  CODE "FILE(INSTALL \${cs_files} DESTINATION \${CMAKE_INSTALL_PREFIX}/bindings/csharp/csocrstudiosdk)"
)
