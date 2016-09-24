# Set _WIN32_WINNT version for WIN32 platform
if(WIN32)
  add_definitions(-D_WIN32_WINNT=0x601)
endif()
