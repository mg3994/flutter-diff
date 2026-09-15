cmake_minimum_required(VERSION 3.10)
project(flutter_zero_native C CXX)

set(CMAKE_C_STANDARD 99)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/c)

if(WIN32)
    add_library(flutter_zero_native SHARED
        c/flutter_zero_native.c
        c/flutter_zero_win32.c
    )
    target_link_libraries(flutter_zero_native user32 gdi32)
elseif(APPLE)
    enable_language(OBJC)
    add_library(flutter_zero_native SHARED
        c/flutter_zero_native.c
        c/flutter_zero_cocoa.m
    )
    target_link_libraries(flutter_zero_native "-framework Cocoa")
elseif(ANDROID)
    add_library(flutter_zero_native SHARED
        c/flutter_zero_native.c
        android/flutter_zero_jni.c
    )
    find_library(log-lib log)
    target_link_libraries(flutter_zero_native ${log-lib})
else()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

    include_directories(${GTK3_INCLUDE_DIRS})
    link_directories(${GTK3_LIBRARY_DIRS})
    add_definitions(${GTK3_CFLAGS_OTHER})

    add_library(flutter_zero_native SHARED
        c/flutter_zero_native.c
        c/flutter_zero_gtk.c
    )
    target_link_libraries(flutter_zero_native ${GTK3_LIBRARIES})
endif()
