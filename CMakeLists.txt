cmake_minimum_required(VERSION 3.14)

project(TestWorkMaps VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(APPLE)
    set (CMAKE_PREFIX_PATH "~/Qt/5.15.2/clang_64/")
endif()

find_package(QT NAMES Qt5 REQUIRED COMPONENTS Core Quick Positioning)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Positioning)

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        PolygoneCore.cpp PolygoneCore.h)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(TestWorkMaps
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET TestWorkMaps APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(TestWorkMaps SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(TestWorkMaps
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(TestWorkMaps
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(TestWorkMaps
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Positioning)

set_target_properties(TestWorkMaps PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER ru.radio.mms.test.work
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(TestWorkMaps)
    qt_finalize_executable(TestWorkMaps)
endif()
