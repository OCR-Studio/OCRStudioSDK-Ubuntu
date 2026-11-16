#!/usr/bin/bash

set -x
set -e

### Checking that the ocrstudiosdk library path is passed as an argument

if [[ $# -ne 2 ]]; then
  echo "Wrong number of parameters: "
  echo "Usage: $0 <PATH_TO_OCRSTUDIOSDK_LIBRARY_DIRECTORY> <VERSION_OF_PYTHON>"
  exit 1
fi

OCRSTUDIOSDK_LIBRARY_PATH="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
BUILD_DIR="$(pwd)"
Python_ADDITIONAL_VERSIONS=$2

### Unpacking, building, and installing (locally) SWIG

cd $BUILD_DIR
tar -xf swig-*.tar.gz
cd swig-*/
./configure --without-pcre --prefix=$BUILD_DIR/swig
make
make install
cd $BUILD_DIR
SWIG_DIR="$($BUILD_DIR/swig/bin/swig -swiglib)"

### Making Python module

mkdir $BUILD_DIR/build
cd $BUILD_DIR/build
cmake .. -DSWIG_EXECUTABLE=$BUILD_DIR/swig/bin/swig \
         -DSWIG_DIR=$SWIG_DIR \
         -DOCRSTUDIOSDK_LIBRARY_PATH=$OCRSTUDIOSDK_LIBRARY_PATH \
         -DPython_ADDITIONAL_VERSIONS=$Python_ADDITIONAL_VERSIONS
make install
