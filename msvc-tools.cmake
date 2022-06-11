# D:\Dev\cmake-3.22.1-windows-x86_64\bin\cmake.exe -G"NMake Makefiles" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Release .. -v > log 2>&1
# D:\Dev\cmake-3.22.1-windows-x86_64\bin\cmake.exe --build . --target test -v
# set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/msvc-tools.cmake)
# for enable all langs by file extension
# project(myproj CXX C ASM_MASM RC)

if(_TOOLCHAIN_INCLUDED)
  return()
endif(_TOOLCHAIN_INCLUDED)
set(_TOOLCHAIN_INCLUDED TRUE)

if(DRIVER)
set(CMAKE_C_COMPILER_WORKS TRUE)
endif()
#set(CMAKE_C_COMPILER_FORCED TRUE)
#set(CMAKE_C_COMPILER_ID_RUN TRUE)
if(DRIVER)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
endif()
#set(CMAKE_CXX_COMPILER_FORCED TRUE)
#set(CMAKE_CXX_COMPILER_ID_RUN TRUE)

function(get_highest_version the_dir the_ver)
  file(GLOB entries LIST_DIRECTORIES true RELATIVE "${the_dir}" "${the_dir}/[0-9.]*")
  foreach(entry ${entries})
    if(IS_DIRECTORY "${the_dir}/${entry}")
      set(${the_ver} "${entry}" PARENT_SCOPE)
    endif()
  endforeach()
endfunction()

set(WINVCROOT "D:/Program Files (x86)/Microsoft Visual Studio/2019/EnterprisePreview")
set(WINSDKROOT "D:/Program Files (x86)/Windows Kits/10")

set(MSVC_VER "14.29.30133")
if (NOT MSVC_VER)
	get_highest_version("D:/Program Files (x86)/Microsoft Visual Studio/2019/EnterprisePreview/VC/Tools/MSVC" MSVC_VER)
endif()
set(VCPATH "D:/Program Files (x86)/Microsoft Visual Studio/2019/EnterprisePreview/VC/Tools/MSVC/${MSVC_VER}")

set(WINSDK_VER "10.0.18362.0")
if (NOT WINSDK_VER)
	get_highest_version("D:/Program Files (x86)/Windows Kits/10/Include" WINSDK_VER)
endif()
set(SDKPATH "D:/Program Files (x86)/Windows Kits/10")

if (NOT MSVC_VER OR NOT WINSDK_VER)
	message(SEND_ERROR "Must specify CMake variable MSVC_VER and WINSDK_VER")
endif()

set(ATLMFC_INCLUDE "${VCPATH}/atlmfc/include")
set(ATLMFC_LIB     "${VCPATH}/atlmfc/lib")
set(MSVC_INCLUDE   "${VCPATH}/include")
set(MSVC_LIB       "${VCPATH}/lib")
set(WINSDK_INCLUDE "${SDKPATH}/Include/${WINSDK_VER}")
set(WINSDK_LIB     "${SDKPATH}/Lib/${WINSDK_VER}")

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

  set(CMAKE_RC_COMPILER "${SDKPATH}/bin/${WINSDK_VER}/x86/rc.exe")
  set(CMAKE_MT "${SDKPATH}/bin/${WINSDK_VER}/x86/mt.exe")

elseif(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x64")

  set(CMAKE_MAKE_PROGRAM "${VCPATH}/bin/Hostx64/x64/nmake.exe")
  set(CMAKE_C_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
  set(CMAKE_CXX_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
  set(CMAKE_ASM_COMPILER "${VCPATH}/bin/Hostx64/x64/ml64.exe")
  set(CMAKE_LINKER "${VCPATH}/bin/Hostx64/x64/link.exe")

  set(CMAKE_RC_COMPILER "${SDKPATH}/bin/${WINSDK_VER}/x64/rc.exe")
  set(CMAKE_MT "${SDKPATH}/bin/${WINSDK_VER}/x64/mt.exe")

else()
  message(FATAL_ERROR "You can not do -DPLATFORM=${PLATFORM} at all, CMake will exit.")
endif()

if(DRIVER)
  include_directories(SYSTEM
    "${SDKPATH}/Include/${WINSDK_VER}/km/crt;"
    "${SDKPATH}/Include/${WINSDK_VER}/shared;"
    "${SDKPATH}/Include/${WINSDK_VER}/km;"
  )
else()
  include_directories(SYSTEM
    "${VCPATH}/include;"
    "${VCPATH}/atlmfc/include;"
    "${SDKPATH}/Include/${WINSDK_VER}/ucrt;"
    "${SDKPATH}/Include/${WINSDK_VER}/shared;"
    "${SDKPATH}/Include/${WINSDK_VER}/um;"
  )
endif()

if(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x32")
  if(DRIVER)
    link_directories(
      "${SDKPATH}/Lib/${WINSDK_VER}/km/x86;"
    )
#  set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES
#	"${SDKPATH}/Lib/${WINSDK_VER}/km/x86;"
#	CACHE STRING "" FORCE)
  else()
    link_directories(
      "${VCPATH}/lib/x86;"
      "${VCPATH}/atlmfc/lib/x86;"
      "${SDKPATH}/Lib/${WINSDK_VER}/ucrt/x86;"
      "${SDKPATH}/Lib/${WINSDK_VER}/um/x86;"
    )
#  set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES
#	"${VCPATH}/lib/x86;"
#	"${VCPATH}/atlmfc/lib/x86;"
#	"${SDKPATH}/Lib/${WINSDK_VER}/ucrt/x86;"
#	"${SDKPATH}/Lib/${WINSDK_VER}/um/x86;"
#	CACHE STRING "" FORCE)
  endif()
#  set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES} CACHE STRING "" FORCE)
elseif(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x64")
  if(DRIVER)
    link_directories(
      "${SDKPATH}/Lib/${WINSDK_VER}/km/x64;"
    )
#  set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES
#	"${SDKPATH}/Lib/${WINSDK_VER}/km/x64;"
#	CACHE STRING "" FORCE)
  else()
    link_directories(
      "${VCPATH}/lib/x64;"
      "${VCPATH}/atlmfc/lib/x64;"
      "${SDKPATH}/Lib/${WINSDK_VER}/ucrt/x64;"
      "${SDKPATH}/Lib/${WINSDK_VER}/um/x64;"
    )
#  set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES
#	"${VCPATH}/lib/x64;"
#	"${VCPATH}/atlmfc/lib/x64;"
#	"${SDKPATH}/Lib/${WINSDK_VER}/ucrt/x64;"
#	"${SDKPATH}/Lib/${WINSDK_VER}/um/x64;"
#	CACHE STRING "" FORCE)
  endif()
#  set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES} CACHE STRING "" FORCE)
endif()

if(DRIVER)
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
set(_W3 " /W3")
if(DRIVER)
  # specifies the __stdcall calling convention for all functions except C++ member functions
  string(APPEND _FLAGS_CXX " /Gz /KERNEL") #/Zc:threadSafeInit- 
  string(APPEND _FLAGS_C " /Gz /KERNEL") #/Zc:threadSafeInit- 
endif()
set(CMAKE_C_FLAGS "/DWIN32 /D_WINDOWS${_W3}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_DEBUG "${_FLAGS_DEBUG} /Ob0 /Od ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "/O2 /Ob2 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} /O2 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)

set(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS${_W3}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "${_FLAGS_DEBUG} /Ob0 /Od ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "/O2 /Ob2 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} /O2 /Ob1 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL "/O1 /Ob1 ${_FLAGS_CXX}" CACHE STRING "" FORCE)

set(CMAKE_MSVC_RUNTIME_LIBRARY "")

if(DRIVER)
#  set(CMAKE_C_CREATE_CONSOLE_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
#  set(CMAKE_CXX_CREATE_CONSOLE_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
#  set(CMAKE_C_CREATE_WIN32_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
#  set(CMAKE_CXX_CREATE_WIN32_EXE "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)

  foreach(t EXE SHARED MODULE)
    set(CMAKE_${t}_LINKER_FLAGS_INIT "/DRIVER /ENTRY:\"DriverEntry\" /SUBSYSTEM:CONSOLE /NODEFAULTLIB" CACHE STRING "" FORCE)
  endforeach()
   set(CMAKE_EXECUTABLE_SUFFIX ".sys" CACHE STRING "" FORCE)
   set_property(GLOBAL PROPERTY SUFFIX ".sys")
   set_property(TARGET PROPERTY SUFFIX ".sys")

   set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS} /MANIFEST:NO")
   set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /MANIFEST:NO")
   set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MANIFEST:NO")
endif()

# Modules\Platform\Windows.cmake
#set(CMAKE_START_TEMP_FILE "" CACHE STRING "" FORCE)
#set(CMAKE_END_TEMP_FILE "" CACHE STRING "" FORCE)
#set(CMAKE_VERBOSE_MAKEFILE 1 CACHE STRING "" FORCE)

#set(CMAKE_C_COMPILER_ID_FLAGS " /link XXX")
#set(CMAKE_CXX_COMPILER_ID_FLAGS " /link XXX")

#set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "marakew_c_imp_inc_dirs" CACHE STRING "" FORCE)
#set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "marakew_cxx_imp_inc_dirs" CACHE STRING "" FORCE)
#set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "marakew_c_imp_inc_dirs1" CACHE STRING "" FORCE)
#set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "marakew_cxx_imp_inc_dirs1" CACHE STRING "" FORCE)

#libs

#set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "marakew_c_imp_link_dirs" CACHE STRING "" FORCE)
#set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "marakew_cxx_imp_link_dirs" CACHE STRING "" FORCE)

#set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "marakew_c_imp_link_libs" CACHE STRING "" FORCE)
#set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "marakew_cxx_imp_link_libs" CACHE STRING "" FORCE)

set(CMAKE_C_COMPILER_ID_LINK_FLAGS_ALWAYS " /link " CACHE STRING "" FORCE)
foreach(dir ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES})
        string(REPLACE "/" "\\" dir ${dir})
	string(APPEND CMAKE_C_COMPILER_ID_LINK_FLAGS_ALWAYS " -LIBPATH:\"${dir}\"")# CACHE STRING "" FORCE)
endforeach()
#string(APPEND CMAKE_C_COMPILER_ID_FLAGS_ALWAYS " /Tc")
#string(PREPEND CMAKE_C_COMPILER_ID_LINK_FLAGS_ALWAYS "/link")

set(CMAKE_CXX_COMPILER_ID_LINK_FLAGS_ALWAYS " /link " CACHE STRING "" FORCE)
foreach(dir ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES})
        string(REPLACE "/" "\\" dir ${dir})
	string(APPEND CMAKE_CXX_COMPILER_ID_LINK_FLAGS_ALWAYS " -LIBPATH:\"${dir}\"")# CACHE STRING "" FORCE)
endforeach()
#string(APPEND CMAKE_CXX_COMPILER_ID_FLAGS_ALWAYS " /Tp")
#string(PREPEND CMAKE_CXX_COMPILER_ID_LINK_FLAGS_ALWAYS "/link")
