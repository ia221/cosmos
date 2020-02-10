# Install script for directory: /home/ia221/cosmos/source/core/tutorials/agents

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/ia221/cosmos")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_001/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_002/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_004/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_005/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_006/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_008/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_add_soh/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_calc/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_cpu_device_test/cmake_install.cmake")
  include("/home/ia221/cosmos/source/core/build/tutorials/agents/agent_talkfree/cmake_install.cmake")

endif()

