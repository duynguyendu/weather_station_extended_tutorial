


cmake_minimum_required(VERSION 3.24)



project(led C ASM)

# Include libraries as needed. One per include statement:
# include(kos_i2c_client)
# include(kosup)

# Declare the 'led' app executable.

add_executable(
    led
    src/main.c
  # src/otherfile.c
)

# To link in libraries, add them after -fhosted (eg)
# target_link_libraries(led -static -fhosted i2c_client)
target_link_libraries(led -static -fhosted)
