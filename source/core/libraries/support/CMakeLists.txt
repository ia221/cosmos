#cmake_minimum_required(VERSION 2.8.12)

#include_directories(${CMAKE_CURRENT_SOURCE_DIR})

FILE(GLOB SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
FILE(GLOB INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/*.h)
FILE(GLOB INCLUDESPP ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)

add_library(CosmosSupport STATIC ${SOURCES} ${INCLUDES})

# support depends on math, so link here
target_link_libraries(CosmosSupport CosmosMath CosmosDeviceCpu CosmosDeviceDisk localzlib)

install(TARGETS CosmosSupport DESTINATION lib)
install(FILES ${INCLUDES} DESTINATION include/support)
install(FILES ${INCLUDESPP} DESTINATION include/support)

if(${DEPLOY_SOURCE_FILES_TO_REMOTE} MATCHES "yes")
    add_deployment_source_directory(${CMAKE_CURRENT_SOURCE_DIR} "src")
endif()
