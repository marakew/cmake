# D:\Dev\cmake-3.22.1-windows-x86_64\bin\cmake.exe -G"NMake Makefiles" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Release .. -v > log 2>&1
# D:\Dev\cmake-3.22.1-windows-x86_64\bin\cmake.exe --build . --target test -v
# set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/msvc-tools.cmake)

#set(CMAKE_C_COMPILER_WORKS TRUE)
#set(CMAKE_C_COMPILER_FORCED TRUE)
#set(CMAKE_C_COMPILER_ID_RUN TRUE)
#set(CMAKE_CXX_COMPILER_WORKS TRUE)
#set(CMAKE_CXX_COMPILER_FORCED TRUE)
#set(CMAKE_CXX_COMPILER_ID_RUN TRUE)

set(VC_VER "14.29.30133")
set(VCPATH "D:/Program Files (x86)/Microsoft Visual Studio/2019/EnterprisePreview/VC/Tools/MSVC/14.29.30133")
set(SDK_VER "10.0.18362.0")
set(SDKPATH "D:/Program Files (x86)/Windows Kits/10")

#message("PLATFORM=${PLATFORM}")
if (NOT DEFINED ENV{PLATFORM})
    set(ENV{PLATFORM} ${PLATFORM})
endif()

if(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x32")

  set(CMAKE_MAKE_PROGRAM "${VCPATH}/bin/Hostx64/x86/nmake.exe")
  set(CMAKE_C_COMPILER "${VCPATH}/bin/Hostx64/x86/cl.exe")
  set(CMAKE_CXX_COMPILER "${VCPATH}/bin/Hostx64/x86/cl.exe")
  set(CMAKE_ASM_COMPILER "${VCPATH}/bin/Hostx64/x86/ml.exe")
  set(CMAKE_LINKER "${VCPATH}/bin/Hostx64/x86/link.exe")

  set(CMAKE_RC_COMPILER "${SDKPATH}/bin/${SDK_VER}/x86/rc.exe")
  set(CMAKE_MT "${SDKPATH}/bin/${SDK_VER}/x86/mt.exe")

elseif(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x64")

  set(CMAKE_MAKE_PROGRAM "${VCPATH}/bin/Hostx64/x64/nmake.exe")
  set(CMAKE_C_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
  set(CMAKE_CXX_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
  set(CMAKE_ASM_COMPILER "${VCPATH}/bin/Hostx64/x64/ml64.exe")
  set(CMAKE_LINKER "${VCPATH}/bin/Hostx64/x64/link.exe")

  set(CMAKE_RC_COMPILER "${SDKPATH}/bin/${SDK_VER}/x64/rc.exe")
  set(CMAKE_MT "${SDKPATH}/bin/${SDK_VER}/x64/mt.exe")

else()
  message(FATAL_ERROR "You can not do -DPLATFORM=${PLATFORM} at all, CMake will exit.")
endif()

if(DRIVER)
  include_directories(SYSTEM
    "${SDKPATH}/Include/${SDK_VER}/km/crt;"
    "${SDKPATH}/Include/${SDK_VER}/shared;"
    "${SDKPATH}/Include/${SDK_VER}/km;"
  )
else()
  include_directories(SYSTEM
    "${VCPATH}/include;"
    "${VCPATH}/atlmfc/include;"
    "${SDKPATH}/Include/${SDK_VER}/ucrt;"
    "${SDKPATH}/Include/${SDK_VER}/shared;"
    "${SDKPATH}/Include/${SDK_VER}/um;"
  )
endif()

if(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x32")
  if(DRIVER)
    link_directories(
      "${SDKPATH}/Lib/${SDK_VER}/km/x86;"
    )
  else()
    link_directories(
      "${VCPATH}/lib/x86;"
      "${VCPATH}/atlmfc/lib/x86;"
      "${SDKPATH}/Lib/${SDK_VER}/ucrt/x86;"
      "${SDKPATH}/Lib/${SDK_VER}/um/x86;"
    )
  endif()
elseif(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x64")
  if(DRIVER)
    link_directories(
      "${SDKPATH}/Lib/${SDK_VER}/km/x64;"
    )
  else()
    link_directories(
      "${VCPATH}/lib/x64;"
      "${VCPATH}/atlmfc/lib/x64;"
      "${SDKPATH}/Lib/${SDK_VER}/ucrt/x64;"
      "${SDKPATH}/Lib/${SDK_VER}/um/x64;"
    )
  endif()
endif()

if(KERNEL)
  set(CMAKE_C_STANDARD_LIBRARIES "libcntpr.lib ntstrsafe.lib BufferOverflowK.lib ntoskrnl.lib hal.lib wdm.lib" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_LIBRARIES "libcntpr.lib ntstrsafe.lib BufferOverflowK.lib ntoskrnl.lib hal.lib wdm.lib" CACHE STRING "" FORCE)
else()
  set(CMAKE_C_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib ws2_32.lib" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib ws2_32.lib" CACHE STRING "" FORCE)
endif()

# clang
#set(_FLAGS_CXX " -frtti -fexceptions")
#string(APPEND _FLAGS_CXX " -fno-strict-aliasing")
#string(APPEND _FLAGS_CXX " -Wno-writable-strings")
#string(APPEND _FLAGS_CXX " -Wno-microsoft-template")
#string(APPEND _FLAGS_CXX " -Wno-deprecated-declarations")

set(_FLAGS_DEBUG "/Zi")
#set(_FLAGS_DEBUG "/Z7")
set(_GR "/GR-") # RTTI - disable
set(_GS "/GS-") # Buffer Security Check - disable
#set(_FLAGS_ARCH "/arch:IA32")
#set(_FLAGS_ARCH "/arch:SSE")
#set(_FLAGS_ARCH "/arch:SSE2")
#set(_FLAGS_ARCH "/arch:AVX")
#set(_FLAGS_ARCH "/arch:AVX2")
#set(_FLAGS_ARCH "/arch:AVX512")
set(_FLAGS_CXX "${_GR} /EHsc")
set(_FLAGS_C "")
if(DRIVER)
  string(APPEND _FLAGS_CXX " /Gz")
  string(APPEND _FLAGS_C " /Gz")
endif()
set(CMAKE_C_FLAGS "/DWIN32 /D_WINDOWS" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_DEBUG "${_FLAGS_DEBUG} /Ob0 /0d ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "/O2 /Ob2 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} /O2 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)

set(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "${_FLAGS_DEBUG} /Ob0 /0d ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "/O2 /Ob2 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} /O2 /Ob1 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL "/O1 /Ob1 ${_FLAGS_CXX}" CACHE STRING "" FORCE)

set(CMAKE_MSVC_RUNTIME_LIBRARY "")

if(DRIVER)
  #set(CMAKE_C_CREATE_CONSOLE_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
  #set(CMAKE_CXX_CREATE_CONSOLE_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
  #set(CMAKE_C_CREATE_WIN32_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
  #set(CMAKE_CXX_CREATE_WIN32_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)

  foreach(t EXE SHARED MODULE)
    set(CMAKE_${t}_LINKER_FLAGS_INIT "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
  endforeach()
endif()
