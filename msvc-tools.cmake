# D:\Dev\cmake-3.22.1-windows-x86_64\bin\cmake.exe -G"NMake Makefiles" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Release .. -v > log 2>&1
# D:\Dev\cmake-3.27.4-windows-x86_64\bin\cmake.exe -G"Ninja" --debug-output --trace --trace-expand --debug-trycompile -DCMAKE_BUILD_TYPE=Release .. -v > log 2>&1
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

if(NOT DEFINED ENV{USE_CLANG})
        if (USE_CLANG)
        set(ENV{USE_CLANG} ${USE_CLANG})
        endif()
else()
set(USE_CLANG $ENV{USE_CLANG})
endif()

if(NOT DEFINED ENV{USE_CLANGCL})
        if (USE_CLANGCL)
        set(ENV{USE_CLANGCL} ${USE_CLANGCL})
        endif()
else()
set(USE_CLANGCL $ENV{USE_CLANGCL})
endif()

# NINJA
if(NOT DEFINED ENV{NINJA_PATH})
	if(NINJA_PATH)
		set(ENV{NINJA_PATH} ${NINJA_PATH})
	else(NOT NINJA_PATH)
		set(NINJA_PATH "D:/Dev")
		set(ENV{NINJA_PATH} ${NINJA_PATH})
	endif()
else()
set(NINJA_PATH $ENV{NINJA_PATH})
endif()
# CLANG
if(NOT DEFINED ENV{CLANG_PATH})
	if(CLANG_PATH)
		set(ENV{CLANG_PATH} ${CLANG_PATH})
	else(NOT CLANG_PATH)
		set(CLANG_PATH "D:")
		set(ENV{CLANG_PATH} ${CLANG_PATH})
	endif()
else()
set(CLANG_PATH $ENV{CLANG_PATH})
endif()

if(NOT DEFINED ENV{CLANG_VER})
	if(CLANG_VER)
		set(ENV{CLANG_VER} ${CLANG_VER})
	else(NOT CLANG_VER)
		set(CLANG_VER "18.x.x")
		set(ENV{CLANG_VER} ${CLANG_VER})
	endif()
else()
set(CLANG_VER $ENV{CLANG_VER})
endif()
#
#set(WINVCROOT "D:/Program Files/Microsoft Visual Studio/2022/EnterprisePreview")
#set(MSVC_VER "14.36.32522")
# WINVC
if(NOT DEFINED ENV{WINVCROOT})
	if(WINVCROOT)
		set(ENV{WINVCROOT} ${WINVCROOT})
	else(NOT WINVCROOT)
		set(WINVCROOT "D:/Program Files (x86)/Microsoft Visual Studio/2019/EnterprisePreview")
		set(ENV{WINVCROOT} ${WINVCROOT})
	endif()
else()
set(WINVCROOT $ENV{WINVCROOT})
endif()

if(NOT DEFINED ENV{MSVC_VER})
	if(MSVC_VER)
		set(ENV{MSVC_VER} ${MSVC_VER})
	else(NOT MSVC_VER)
		set(MSVC_VER "14.29.30133")
		set(ENV{MSVC_VER} ${MSVC_VER})
	endif()
else()
set(MSVC_VER $ENV{MSVC_VER})
endif()
# WINSDK
if(NOT DEFINED ENV{WINSDKROOT})
	if(WINSDKROOT)
		set(ENV{WINSDKROOT} ${WINSDKROOT})
	else(NOT WINSDKROOT)
		set(WINSDKROOT "D:/Program Files (x86)/Windows Kits/10")
		set(ENV{WINSDKROOT} ${WINSDKROOT})
	endif()
else()
set(WINSDKROOT $ENV{WINSDKROOT})
endif()

if(NOT DEFINED ENV{WINSDK_VER})
	if(WINSDK_VER)
		set(ENV{WINSDK_VER} ${WINSDK_VER})
	else(NOT WINSDK_VER)
		set(WINSDK_VER "10.0.18362.0")
		set(ENV{WINSDK_VER} ${WINSDK_VER})
	endif()
else()
set(WINSDK_VER $ENV{WINSDK_VER})
endif()
#########

if(NOT MSVC_VER)
	get_highest_version("${WINVCROOT}/VC/Tools/MSVC" MSVC_VER)
endif()
set(VCPATH "${WINVCROOT}/VC/Tools/MSVC/${MSVC_VER}")

if(NOT WINSDK_VER)
	get_highest_version("${WINSDKROOT}/Include" WINSDK_VER)
endif()
set(SDKPATH "${WINSDKROOT}")

if(NOT MSVC_VER OR NOT WINSDK_VER)
	message(SEND_ERROR "Must specify CMake variable MSVC_VER and WINSDK_VER")
endif()

set(ATLMFC_INCLUDE "${VCPATH}/atlmfc/include")
set(ATLMFC_LIB     "${VCPATH}/atlmfc/lib")
set(MSVC_INCLUDE   "${VCPATH}/include")
set(MSVC_LIB       "${VCPATH}/lib")
set(WINSDK_INCLUDE "${SDKPATH}/Include/${WINSDK_VER}")
set(WINSDK_LIB     "${SDKPATH}/Lib/${WINSDK_VER}")

#message("PLATFORM=${PLATFORM}")
if(NOT DEFINED ENV{PLATFORM})
    set(ENV{PLATFORM} ${PLATFORM})
endif()

if(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x32")

set(NASM_EXE D:/Dev/nasm-2.16rc12-win32/nasm.exe)
set(CMAKE_ASM_NASM_COMPILER ${NASM_EXE})

if(CMAKE_GENERATOR MATCHES "Ninja")
  set(CMAKE_MAKE_PROGRAM "${NINJA_PATH}/ninja.exe" CACHE FILEPATH "" FORCE)
else()
  set(CMAKE_MAKE_PROGRAM "${VCPATH}/bin/Hostx64/x86/nmake.exe")
endif()

if(USE_CLANGCL)
  set(CMAKE_C_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win32/bin/clang-cl.exe")
  set(CMAKE_CXX_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win32/bin/clang-cl.exe")
elseif(USE_CLANG)
  set(CMAKE_C_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win32/bin/clang.exe")
  set(CMAKE_CXX_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win32/bin/clang++.exe")
else()
  set(CMAKE_C_COMPILER "${VCPATH}/bin/Hostx64/x86/cl.exe")
  set(CMAKE_CXX_COMPILER "${VCPATH}/bin/Hostx64/x86/cl.exe")
endif()
  set(CMAKE_ASM_COMPILER "${VCPATH}/bin/Hostx64/x86/ml.exe")
  set(CMAKE_ASM_MASM_COMPILER "${VCPATH}/bin/Hostx64/x86/ml.exe")
  set(CMAKE_LINKER "${VCPATH}/bin/Hostx64/x86/link.exe")

  set(CMAKE_RC_COMPILER "${SDKPATH}/bin/${WINSDK_VER}/x86/rc.exe")
  set(CMAKE_MT "${SDKPATH}/bin/${WINSDK_VER}/x86/mt.exe")

elseif(DEFINED ENV{PLATFORM} AND $ENV{PLATFORM} STREQUAL "x64")

set(NASM_EXE D:/Dev/nasm-2.16rc12-win64/nasm.exe)
set(CMAKE_ASM_NASM_COMPILER ${NASM_EXE})

if(CMAKE_GENERATOR MATCHES "Ninja")
  set(CMAKE_MAKE_PROGRAM "${NINJA_PATH}/ninja.exe" CACHE FILEPATH "" FORCE)
else()
  set(CMAKE_MAKE_PROGRAM "${VCPATH}/bin/Hostx64/x64/nmake.exe")
endif()

if(USE_CLANGCL)
  set(CMAKE_C_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win64/bin/clang-cl.exe")
  set(CMAKE_CXX_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win64/bin/clang-cl.exe")
elseif(USE_CLANG)
  set(CMAKE_C_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win64/bin/clang.exe")
  set(CMAKE_CXX_COMPILER "${CLANG_PATH}/LLVM-${CLANG_VER}-win64/bin/clang++.exe")
else()
  set(CMAKE_C_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
  set(CMAKE_CXX_COMPILER "${VCPATH}/bin/Hostx64/x64/cl.exe")
endif()
  set(CMAKE_ASM_COMPILER "${VCPATH}/bin/Hostx64/x64/ml64.exe")
  set(CMAKE_ASM_MASM_COMPILER "${VCPATH}/bin/Hostx64/x64/ml64.exe")
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
    "${SDKPATH}/Include/${WINSDK_VER}/winrt;"
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

if(USE_CLANG)
  return()
endif()

if(DRIVER)
  set(CMAKE_C_STANDARD_LIBRARIES "libcntpr.lib ntstrsafe.lib BufferOverflowK.lib ntoskrnl.lib hal.lib wdm.lib" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_LIBRARIES "libcntpr.lib ntstrsafe.lib BufferOverflowK.lib ntoskrnl.lib hal.lib wdm.lib" CACHE STRING "" FORCE)
else()
  set(CMAKE_C_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib ws2_32.lib" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib ws2_32.lib" CACHE STRING "" FORCE)
endif()

# clang-cl
##string(APPEND _FLAGS_CXX " -fno-strict-aliasing")
##string(APPEND _FLAGS_CXX " -Wno-writable-strings")
##string(APPEND _FLAGS_CXX " -Wno-microsoft-template")
##string(APPEND _FLAGS_CXX " -Wno-deprecated-declarations")

#set(CMAKE_C_FLAGS "/DWIN32 -fms-extensions -fms-compatibility -D_WINDOWS${_Wall}" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS_DEBUG "${_FLAGS_DEBUG} -gline-tables-only -fno-inline -O0 ${_FLAGS_C}" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS_RELEASE "-O2 ${_FLAGS_C}" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} -gline-tables-only -O2 -fno-inline ${_FLAGS_C}" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS_MINSIZEREL "${_FLAGS_C}" CACHE STRING "" FORCE)

#set(CMAKE_CXX_FLAGS "/DWIN32 -fms-extensions -fms-compatibility -D_WINDOWS${_Wall}" CACHE STRING "" FORCE)
#set(CMAKE_CXX_FLAGS_DEBUG "${_FLAGS_DEBUG} -gline-tables-only -fno-inline -O0 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
#set(CMAKE_CXX_FLAGS_RELEASE "-O2 ${_FLAGS_CXX}" CACHE STRING "" FORCE)
#set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} -gline-tables-only -O2 -fno-inline ${_FLAGS_CXX}" CACHE STRING "" FORCE)
#set(CMAKE_CXX_FLAGS_MINSIZEREL "${_FLAGS_CXX}" CACHE STRING "" FORCE)

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
#set(_W3 " /W3")
set(_W3 "")
string(APPEND _W3 " /W4") # Baseline reasonable warnings
if(NOT USE_CLANGCL)
string(APPEND _W3 " /w14242") # 'identifier': conversion from 'type1' to 'type1', possible loss of data
string(APPEND _W3 " /w14254") # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
string(APPEND _W3 " /w14263") # 'function': member function does not override any base class virtual member function
string(APPEND _W3 " /w14265") # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not
				# be destructed correctly
string(APPEND _W3 " /w14287") # 'operator': unsigned/negative constant mismatch
string(APPEND _W3 " /we4289") # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside
				# the for-loop scope
string(APPEND _W3 " /w14296") # 'operator': expression is always 'boolean_value'
string(APPEND _W3 " /w14311") # 'variable': pointer truncation from 'type1' to 'type2'
string(APPEND _W3 " /w14545") # expression before comma evaluates to a function which is missing an argument list
string(APPEND _W3 " /w14546") # function call before comma missing argument list
string(APPEND _W3 " /w14547") # 'operator': operator before comma has no effect; expected operator with side-effect
string(APPEND _W3 " /w14549") # 'operator': operator before comma has no effect; did you intend 'operator'?
string(APPEND _W3 " /w14555") # expression has no effect; expected expression with side- effect
string(APPEND _W3 " /w14619") # pragma warning: there is no warning number 'number'
string(APPEND _W3 " /w14640") # Enable warning on thread un-safe static member initialization
string(APPEND _W3 " /w14826") # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
string(APPEND _W3 " /w14905") # wide string literal cast to 'LPSTR'
string(APPEND _W3 " /w14906") # string literal cast to 'LPWSTR'
string(APPEND _W3 " /w14928") # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
endif()
string(APPEND _W3 " /permissive-") # standards conformance mode for MSVC compiler.
if(USE_CLANG OR USE_CLANGCL)
string(APPEND _W3 " -Wall")
string(APPEND _W3 " -Wextra") # reasonable and standard
string(APPEND _W3 " -Wshadow") # warn the user if a variable declaration shadows one from a parent context
string(APPEND _W3 " -Wnon-virtual-dtor") # warn the user if a class with virtual functions has a non-virtual destructor. This helps
					# catch hard to track down memory errors
#string(APPEND _W3 " -Wold-style-cast") # warn for c-style casts
#string(APPEND _W3 " -Wcast-align") # warn for potential performance problem casts
string(APPEND _W3 " -Wunused") # warn on anything being unused
string(APPEND _W3 " -Woverloaded-virtual") # warn if you overload (not override) a virtual function
string(APPEND _W3 " -Wpedantic") # warn if non-standard C++ is used
string(APPEND _W3 " -Wconversion") # warn on type conversions that may lose data
string(APPEND _W3 " -Wsign-conversion") # warn on sign conversions
string(APPEND _W3 " -Wnull-dereference") # warn if a null dereference is detected
#string(APPEND _W3 " -Wdouble-promotion") # warn if float is implicit promoted to double
string(APPEND _W3 " -Wformat=2") # warn on security issues around functions that format output (ie printf)
string(APPEND _W3 " -Wno-unsafe-buffer-usage") #-fsafe-buffer-usage-suggestions
string(APPEND _W3 " -Wno-documentation")
string(APPEND _W3 " -Wno-documentation-unknown-command")
string(APPEND _W3 " -Wno-nonportable-system-include-path")
string(APPEND _W3 " -Wno-extra-semi-stmt")
string(APPEND _W3 " -Wno-extra-semi")
string(APPEND _W3 " -Wno-undef")
string(APPEND _W3 " -Wno-comma")
string(APPEND _W3 " -Wno-c++98-compat")
string(APPEND _W3 " -Wno-c++98-compat-pedantic")
string(APPEND _W3 " -Wno-unused-macros")
string(APPEND _W3 " -Wno-old-style-cast")
string(APPEND _W3 " -Wno-newline-eof")
string(APPEND _W3 " -Wno-reserved-macro-identifier")
string(APPEND _W3 " -Wno-zero-as-null-pointer-constant") # 0,NULL -> nullptr
string(APPEND _W3 " -Wno-language-extension-token")
string(APPEND _W3 " -Wno-reserved-identifier")
string(APPEND _W3 " -Wno-missing-variable-declarations")
string(APPEND _W3 " -Wno-declaration-after-statement")
string(APPEND _W3 " -Wno-gnu-anonymous-struct")
string(APPEND _W3 " -Wno-nested-anon-types")
string(APPEND _W3 " -Wno-global-constructors")
string(APPEND _W3 " -Wno-shadow-field")
string(APPEND _W3 " -Wno-shadow-field-in-constructor")
string(APPEND _W3 " -Wno-exit-time-destructors")
string(APPEND _W3 " -Wno-used-but-marked-unused")
string(APPEND _W3 " -Wno-four-char-constants")
string(APPEND _W3 " -Wno-sign-conversion")
#string(APPEND _W3 " -Wno-sign-compare")
string(APPEND _W3 " -Wno-implicit-int-float-conversion")
string(APPEND _W3 " -Wno-redundant-parens")
string(APPEND _W3 " -Wno-deprecated-redundant-constexpr-static-def")
string(APPEND _W3 " -Wno-suggest-destructor-override")
string(APPEND _W3 " -Wno-double-promotion")
string(APPEND _W3 " -Wno-implicit-float-conversion")
string(APPEND _W3 " -Wno-float-conversion")
string(APPEND _W3 " -Wno-cast-align")
string(APPEND _W3 " -Wno-cast-qual")
string(APPEND _W3 " -Wno-disabled-macro-expansion")
string(APPEND _W3 " -Wno-gnu-zero-variadic-macro-arguments")
string(APPEND _W3 " -Wno-microsoft-include")
string(APPEND _W3 " -Wno-microsoft-cpp-macro")
string(APPEND _W3 " -Wno-microsoft-enum-value")
string(APPEND _W3 " -Wno-cast-function-type-strict")
string(APPEND _W3 " -Wno-cast-function-type")
string(APPEND _W3 " -Wno-missing-prototypes")
string(APPEND _W3 " -Wno-missing-noreturn")
string(APPEND _W3 " -Wno-inconsistent-missing-destructor-override")
#string(APPEND _W3 " -Wno-implicit-int-conversion")
#string(APPEND _W3 " -Wno-shorten-64-to-32")
string(APPEND _W3 " -Wno-float-equal")
string(APPEND _W3 " -Wno-switch-enum")
string(APPEND _W3 " -Wno-deprecated-literal-operator")
string(APPEND _W3 " -Wno-covered-switch-default")
string(APPEND _W3 " -Wno-format-nonliteral")
string(APPEND _W3 " -Wno-strict-prototypes")
string(APPEND _W3 " -Wno-static-in-inline")
string(APPEND _W3 " -Wno-deprecated-copy-with-user-provided-dtor")
string(APPEND _W3 " -Wno-unused-exception-parameter")
string(APPEND _W3 " -Wno-absolute-value")
string(APPEND _W3 " -Wno-bad-function-cast")
string(APPEND _W3 " -Wno-unused-function")
string(APPEND _W3 " -Wno-switch-default")
string(APPEND _W3 " -Wno-suggest-override")
string(APPEND _W3 " -Wno-implicit-fallthrough")
string(APPEND _W3 " -Wno-tautological-type-limit-compare")
string(APPEND _W3 " -Wno-implicit-int-conversion")
string(APPEND _W3 " -Wno-invalid-utf8")
string(APPEND _W3 " -Wno-unused-template")
endif()

if(DRIVER)
  # specifies the __stdcall calling convention for all functions except C++ member functions
  string(APPEND _FLAGS_CXX " /Gz /KERNEL") #/Zc:threadSafeInit- 
  string(APPEND _FLAGS_C " /Gz /KERNEL") #/Zc:threadSafeInit- 
endif()

set(PLATFORM_COMPAT)
if(USE_CLANGCL)
string(APPEND PLATFORM_COMPAT " -fms-extensions -fms-compatibility")
endif()
set(CMAKE_C_FLAGS "/DWIN32 /D_WINDOWS${PLATFORM_COMPAT}${_W3}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_DEBUG "${_FLAGS_DEBUG} /Ob0 /Od ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "/O2 /Ob2 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${_FLAGS_DEBUG} /O2 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Ob1 ${_FLAGS_C}" CACHE STRING "" FORCE)

set(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS${PLATFORM_COMPAT}${_W3}" CACHE STRING "" FORCE)
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
