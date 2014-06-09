cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(watertight)

find_package(PCL 1.2 REQUIRED)

find_package(VTK REQUIRED)
include_directories(${VTK_INCLUDE_DIRS})
link_directories(${VTK_LIBRARY_DIRS})

include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

add_executable (watertight main.cpp)
target_link_libraries (watertight ${PCL_LIBRARIES} ${VTK_LIBRARIES})
