#!/usr/bin/bash

set -x
set -e

### Checking that the OCRStudioSDK library path is passed as an argument

if [[ $# -ne 1 ]]; then
  echo "Wrong number of parameters: "
  echo "Usage: $0 <PATH_TO_OCRSTUDIOSDK_LIBRARY_DIRECTORY>"
  exit 1
fi

OCRSTUDIOSDK_LIBRARY_PATH="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
BUILD_DIR="$(pwd)"

### Unpacking, building, and installing (locally) SWIG

cd $BUILD_DIR
tar -xf swig-*.tar.gz
cd swig-*/
./configure --without-pcre --prefix=$BUILD_DIR/swig
make
make install
cd $BUILD_DIR
SWIG_DIR="$($BUILD_DIR/swig/bin/swig -swiglib)"


### Making Csharp module

mkdir $BUILD_DIR/build
cd $BUILD_DIR/build
cmake .. -DSWIG_EXECUTABLE=$BUILD_DIR/swig/bin/swig \
         -DSWIG_DIR=$SWIG_DIR \
         -DOCRSTUDIOSDK_LIBRARY_PATH=$OCRSTUDIOSDK_LIBRARY_PATH
make install
