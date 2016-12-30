# Find packages
find_package(Threads REQUIRED)

# System link libraries
list(APPEND SYSLIBS Threads::Threads)
