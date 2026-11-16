# DESCRIPTION: 
#   This script is designed to locally build PHP integration module for ocrstudiosdk library.
# 
# MOTIVATION:
#   Version of the PHP module development libraries has to exactly correspond to the version
#   of the PHP runtime libraries. Thus if the PHP modules built on external SDK build machines
#   is different from the version used on client's machine, the PHP integration module will not
#   be operational. The local build will guarantee that the PHP versions match.
#
# REQUIREMENTS:
#   cmake - version 3.0 or higher. Required for building the PHP module.
#   gcc/g++ - version 4.8 or higher. These are required for running OCRStudioSDK native
#      libraries anyway, and for building the wrapping PHP module. 
#      If you are running CentOS 6, the compilers can be installed using devtoolset-2 
#      (see https://gist.github.com/giwa/b1fb1e44dc0a7d270881).
#      Don't forget to switch environments using 'scl enable devtoolset-2 bash'.
#      php-cli: module-development libraries should be available
#
# HOWTO:
#   1. Run this script from its local directory with two parameters - the path to the directory
#      containing libocrstudiosdk.so installed in your system ("../../bin" if you simply are using 
#      the unpacked SDK) and the path to system php-config (exact the same version as your php interpreter) 
#      Keep in mind that the built PHP module will link to the absolute path
#      to the libocrstudiosdk.so library.
#   2. When this script is finished, the compiled module will be placed in ../../bin 
#      directory.
#   3. Check the sample: $ php -c php.ini ocrstudiosdk_sample_php.php <path_to_image> <path_to_config*.ocr> <target_mask>
#
# OVERVIEW:
#   - First, the script unpacks, configures the sources with a local install prefix, 
#     builds and installs SWIG (not in the system, simply in the local folder).
#     SWIG sources is placed here, it also can be downloaded from 
#     https://downloads.sourceforge.net/project/swig/swig/swig-4.1.1/swig-4.1.1.tar.gz for SWIG 4.1.1
#     or
#     https://downloads.sourceforge.net/project/swig/swig/swig-4.4.1/swig-4.4.1.tar.gz for SWIG 4.4.1
#   - Next, a module build directory is created and the module is built according
#     to the CMake script provided. Local SWIG build will be used to generate the 
#     wrapper, and $1-st argument of this script will be used to find the 
#     libocrstudiosdk.so library to link with.
