#-------------------------------------------------------------------
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------

project(OgreMeshy)

cmake_minimum_required(VERSION 3.10)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_STANDARD 11)

set(MESHY_USE_RTSS TRUE CACHE BOOL "use RTSS")


# Download cotire automatically
if (NOT EXISTS "${CMAKE_BINARY_DIR}/cotire.cmake")
    message(STATUS "Downloading cotire.cmake from https://github.com/sakra/cotire/")
    file(DOWNLOAD "https://raw.githubusercontent.com/sakra/cotire/master/CMake/cotire.cmake"
            "${CMAKE_BINARY_DIR}/cotire.cmake")
endif ()

include(${CMAKE_BINARY_DIR}/cotire.cmake)

include(CMake/pmm.cmake)
pmm(DEBUG CONAN 
    REMOTES ror-dependencies https://api.bintray.com/conan/anotherfoxguy/ror-dependencies
    bincrafters-public-conan https://api.bintray.com/conan/bincrafters/public-conan
 )

if (UNIX)
    find_package(wxWidgets REQUIRED core base aui adv)
    find_package(GTK2 REQUIRED gtk)
endif ()

include(CMake/Install.cmake)


# Setup our application
if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
    add_definitions(-DUNICODE -D_UNICODE)
endif ()

file(GLOB_RECURSE SOURCES "${CMAKE_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE HEADERS "${CMAKE_SOURCE_DIR}/include/*.h")

include_directories("${CMAKE_SOURCE_DIR}/include")

if (WIN32)
    # Add embedded icon
    set(SOURCES ${SOURCES}  "${CMAKE_SOURCE_DIR}/scripts/Resources/Resource.rc")
endif ()

add_executable(${PROJECT_NAME} WIN32 ${SOURCES} ${HEADERS})

if (WIN32)
    target_include_directories(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE CONAN_PKG::wxwidgets)
    target_link_libraries(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE CONAN_PKG::wxwidgets)
else ()
    target_include_directories(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE)
    target_link_libraries(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE)

    include_directories(${GTK2_INCLUDE_DIRS})
    add_definitions(${GTK2_DEFINITIONS})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${GTK2_LIBRARIES})


    include(${wxWidgets_USE_FILE})
    add_definitions(-DwxUSE_GUI=1)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${wxWidgets_LIBRARIES})
endif ()

if(MESHY_USE_RTSS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE MESHY_USE_RTSS)
endif()

configure_file(${CMAKE_SOURCE_DIR}/CMake/Templates/Plugins.cfg.in ${CMAKE_BINARY_DIR}/bin/plugins.cfg)
set_target_properties(${PROJECT_NAME} PROPERTIES COTIRE_ADD_UNITY_BUILD FALSE)
cotire(${PROJECT_NAME})


add_custom_target(
    copy_resources
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Fonts  ${CMAKE_BINARY_DIR}/bin/Resources/Fonts
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Icons  ${CMAKE_BINARY_DIR}/bin/Resources/Icons
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Other  ${CMAKE_BINARY_DIR}/bin/Resources/Models
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Models ${CMAKE_BINARY_DIR}/bin/Resources/Models
    COMMENT "Copy resources to build directory"
    VERBATIM
)

setupInstallers()

include(FeatureSummary)
feature_summary(WHAT ALL)
