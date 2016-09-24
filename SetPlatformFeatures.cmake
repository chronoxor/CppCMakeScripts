# Detect _WIN32_WINNT version
if(WIN32)
  macro(GET_WIN32_WINNT version)
    if (WIN32 AND CMAKE_SYSTEM_VERSION)
      set(ver ${CMAKE_SYSTEM_VERSION})
      string(REGEX REPLACE "^([0-9])[.]([0-9]).*" "0\\10\\2" ver ${ver})
      set(${version} "0x${ver}")
    endif()
  endmacro()

  GET_WIN32_WINNT(winnt)
  add_definitions(-D_WIN32_WINNT=${winnt})
endif()
