# Windows platform
if(WIN32)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
  add_definitions(-D_WIN32_WINNT=0x0A00)
endif()
