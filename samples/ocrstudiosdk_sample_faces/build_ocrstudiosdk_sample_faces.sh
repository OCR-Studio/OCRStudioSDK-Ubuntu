g++ ocrstudiosdk_sample_faces.cpp -O2 -std=c++11 -I ../../include -L ../../bin -l ocrstudiosdk -o ocrstudiosdk_sample_faces -Wl,-rpath,../../bin

# Execution example
# LD_LIBRARY_PATH=../../bin ./ocrstudiosdk_sample_faces <image_path_lvalue> <image_path_rvalue> <config_path>
