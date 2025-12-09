


cmake_minimum_required(VERSION 3.24)



project(weather_sensor C ASM)

# Include libraries as needed. One per include statement:
# include(kos_i2c_client)
# include(kosup)

# Declare the 'weather_sensor' app executable.

add_executable(
    weather_sensor
    src/main.c
  # src/otherfile.c
)

# To link in libraries, add them after -fhosted (eg)
# target_link_libraries(weather_sensor -static -fhosted i2c_client)
target_link_libraries(weather_sensor -static -fhosted)
