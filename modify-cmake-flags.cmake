
foreach(l IN ITEMS C CXX)
  foreach(c IN ITEMS DEBUG MINSIZEREL RELEASE RELWITHDEBINFO)
#     message(STATUS "${CMAKE_${l}_FLAGS_${c}}")
     string(REPLACE "/GR-" "" "CMAKE_${l}_FLAGS_${c}" "${CMAKE_${l}_FLAGS_${c}}")
#     message(STATUS "${CMAKE_${l}_FLAGS_${c}}")
  endforeach()
endforeach()
