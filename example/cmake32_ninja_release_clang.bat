cmake.bat -G"Ninja" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Release -Bbuild . -DPLATFORM=x32 -DUSE_CLANG=1 > build32_release.log 2>&1