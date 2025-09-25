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


### Unpacking, building, and installing (locally) SWIG 4.1.1

cd $BUILD_DIR
tar -xf swig-4.1.1.tar.gz
cd swig-4.1.1
./configure --without-pcre --prefix=$BUILD_DIR/swig
make
make install
cd ../..

### Making Python module

mkdir -p $BUILD_DIR/build
cd $BUILD_DIR/build
cmake .. -DSWIG_EXECUTABLE=$BUILD_DIR/swig/bin/swig \
         -DSWIG_DIR=$BUILD_DIR/swig/share/swig/4.1.1 \
         -DOCRSTUDIOSDK_LIBRARY_PATH=$OCRSTUDIOSDK_LIBRARY_PATH \
         -DPython_ADDITIONAL_VERSIONS=$Python_ADDITIONAL_VERSIONS 
make install

