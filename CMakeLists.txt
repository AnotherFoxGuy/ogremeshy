#-------------------------------------------------------------------
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------
cmake_minimum_required(VERSION 3.10)


project(OgreMeshy VERSION 1.11)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
#set(CMAKE_CXX_STANDARD 14)

set(MESHY_USE_RTSS TRUE CACHE BOOL "use RTSS")

include(CMake/pmm.cmake)
pmm(CONAN REMOTES ror-dependencies https://api.bintray.com/conan/anotherfoxguy/ror-dependencies BINCRAFTERS
        CMakeCM ROLLING)

include(cotire)

if (UNIX)
    find_package(GTK2 REQUIRED gtk)
endif ()

include(CMake/Install.cmake)

SET(RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/")
SET(LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/")
SET(ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/")

# Setup our application
if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
    add_definitions(-DUNICODE -D_UNICODE)
endif ()

file(GLOB_RECURSE SOURCES "${CMAKE_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE HEADERS "${CMAKE_SOURCE_DIR}/include/*.h")

include_directories("${CMAKE_SOURCE_DIR}/include")

if (WIN32)
	# fix executable paths for windows
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${RUNTIME_OUTPUT_DIRECTORY})
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${RUNTIME_OUTPUT_DIRECTORY})
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${RUNTIME_OUTPUT_DIRECTORY})
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${RUNTIME_OUTPUT_DIRECTORY})

    # Add embedded icon
    set(SOURCES ${SOURCES}  "${CMAKE_SOURCE_DIR}/scripts/Resources/Resource.rc")
endif ()

add_executable(${PROJECT_NAME} WIN32 ${SOURCES} ${HEADERS})

target_include_directories(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE CONAN_PKG::wxwidgets)
target_link_libraries(${PROJECT_NAME} PRIVATE CONAN_PKG::OGRE CONAN_PKG::wxwidgets)

if (UNIX)
    include_directories(${GTK2_INCLUDE_DIRS})
    add_definitions(${GTK2_DEFINITIONS})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${GTK2_LIBRARIES})
endif ()

if(MESHY_USE_RTSS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE MESHY_USE_RTSS)
endif()

configure_file(${CMAKE_SOURCE_DIR}/CMake/Templates/Plugins.cfg.in ${CMAKE_BINARY_DIR}/bin/plugins.cfg)
set_target_properties(${PROJECT_NAME} PROPERTIES COTIRE_ADD_UNITY_BUILD FALSE)
cotire(${PROJECT_NAME})


add_custom_target(
    copy_resources
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Fonts  ${RUNTIME_OUTPUT_DIRECTORY}/Resources/Fonts
  	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Icons  ${RUNTIME_OUTPUT_DIRECTORY}/Resources/Icons
  	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Other  ${RUNTIME_OUTPUT_DIRECTORY}/Resources/Models
  	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts/Resources/Models ${RUNTIME_OUTPUT_DIRECTORY}/Resources/Models
    COMMENT "Copy resources to build directory"
    VERBATIM
)

setupInstallers()

include(FeatureSummary)
feature_summary(WHAT ALL)
