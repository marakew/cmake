cmake.bat -G"Ninja" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Debug -Bbuild . -DPLATFORM=x64 -DUSE_CLANG=1 > build64_debug.log 2>&1