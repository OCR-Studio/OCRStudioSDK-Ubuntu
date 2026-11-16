gcc ocrstudiosdk_c_sample.c -O2 -I ../../bindings/c -L ../../bin -l cocrstudiosdk -o ocrstudiosdk_c_sample -Wl,-rpath,../../bin

# Execution example
# LD_LIBRARY_PATH=../../bin ./ocrstudiosdk_c_sample <image_path> <config_path> <target_mask>
