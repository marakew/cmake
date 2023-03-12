
# example of usage

#cmake_minimum_required(VERSION 3.22)

#set(CMAKE_TOOLCHAIN_FILE L:/git_my/cmake/msvc-tools.cmake)

#project(test)
# >>>

#include(L:/git_my/cmake/msvc-showcmd.cmake)

foreach(l IN ITEMS C CXX)
  foreach(c IN ITEMS DEBUG MINSIZEREL RELEASE RELWITHDEBINFO)
#     message(STATUS "${CMAKE_${l}_FLAGS_${c}}")
     string(REPLACE "/GR-" "" "CMAKE_${l}_FLAGS_${c}" "${CMAKE_${l}_FLAGS_${c}}")
#     message(STATUS "${CMAKE_${l}_FLAGS_${c}}")
  endforeach()
endforeach()

# <<<
#set(CMAKE_CXX_STANDARD 20)
