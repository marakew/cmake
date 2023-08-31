
https://stackoverflow.com/questions/53692348/cmake-platform-independent-binary-stripping-for-release-builds

1)

# Strip binary for release builds

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND $<$<CONFIG:release>:${CMAKE_STRIP} ${PROJECT_NAME}>)

2)

add_custom_command(
  TARGET "${TARGET}" POST_BUILD
  DEPENDS "${TARGET}"
  COMMAND $<$<CONFIG:release>:${CMAKE_STRIP}>
  ARGS --strip-all $<TARGET_FILE:${TARGET}>
)
