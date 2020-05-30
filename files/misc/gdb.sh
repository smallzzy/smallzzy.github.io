# attach to remote
set sysroot /
target remote localhost:4444

# set breakpoint
set breakpoint pending on
# b toco::(anonymous namespace)::GraphTransformationsPass
b toco::TransformWithStatus

# set source directory
dir ~/develop/tflite/tensorflow
