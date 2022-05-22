
#https://stackoverflow.com/questions/57358039/how-to-see-the-underlying-compiler-linker-command-line-with-cmake-nmake

# append after project()

set(CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES 0 FORCE)
foreach(lang IN ITEMS C CXX)
    foreach(cmd IN ITEMS COMPILE_OBJECT CREATE_SHARED_LIBRARY CREATE_PREPROCESSED_SOURCE CREATE_ASSEMBLY_SOURCE LINK_EXECUTABLE)
        string(REPLACE "${CMAKE_START_TEMP_FILE}" "" CMAKE_${lang}_${cmd} "${CMAKE_${lang}_${cmd}}")
        string(REPLACE "${CMAKE_END_TEMP_FILE}" "" CMAKE_${lang}_${cmd} "${CMAKE_${lang}_${cmd}}")
    endforeach()
endforeach()
