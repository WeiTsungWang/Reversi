cmake_minimum_required(VERSION 3.16)

project(Reversi1 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appReversi1
    main.cpp
    resourse.qrc
)

qt_add_qml_module(appReversi1
    URI Reversi1
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES PlayWindow.qml
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES
        SOURCES SettingsManager.h
        SOURCES SettingsManager.cpp
        SOURCES chessActivity.h
        SOURCES chess.h
        SOURCES chess.cpp
        SOURCES chessActivity.cpp
        SOURCES GetterAndSetter.cpp
        RESOURCES
        RESOURCES resourse.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appReversi1 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appReversi1
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appReversi1
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appReversi1
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
