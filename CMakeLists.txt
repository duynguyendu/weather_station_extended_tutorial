

cmake_minimum_required(VERSION 3.24)

# Set the KOS environment sources
set(CMAKE_C_COMPILER $ENV{KOS_CC})
set(CMAKE_TOOLCHAIN_FILE $ENV{KOS_RUNTIME_PATH}/share/toolchain.cmake)
list(APPEND CMAKE_MODULE_PATH $ENV{KOS_BUILTINS_PATH}/share)

project(Superbuild NONE)

# Check if the platform has changed since this binary was compiled
set(PLATFORM_SPEC_FILE "${CMAKE_BINARY_DIR}/platform_spec.txt")
if(EXISTS "${PLATFORM_SPEC_FILE}")
	file(READ "${PLATFORM_SPEC_FILE}" FILE_CONTENTS)
	string(STRIP "${FILE_CONTENTS}" FILE_CONTENTS)
	set(PREVIOUS_PLATFORM_SPEC "${FILE_CONTENTS}")
else()
    set(PREVIOUS_PLATFORM_SPEC "")
endif()

if (NOT ${PREVIOUS_PLATFORM_SPEC} STREQUAL "" AND NOT "$ENV{KOS_PLATFORM_SPEC}" STREQUAL "${PREVIOUS_PLATFORM_SPEC}")
	message( FATAL_ERROR "The C apps were already compiled for ${PREVIOUS_PLATFORM_SPEC}. Please remove ${CMAKE_BINARY_DIR} (eg by running `rm -rf _build` or build elsewhere")
endif()
file(WRITE "${PLATFORM_SPEC_FILE}" "$ENV{KOS_PLATFORM_SPEC}")
# End compiler check

# Automatically include all C apps in the apps/ directory
file(GLOB APP_ENTRIES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/apps"
     "${CMAKE_CURRENT_SOURCE_DIR}/apps/*")

foreach(entry ${APP_ENTRIES})
  # Check if the entry is a directory with a CMakeLists.txt file.
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/apps/${entry}/CMakeLists.txt")
    add_subdirectory("apps/${entry}")
  endif()
endforeach()
# End C app inclusion
