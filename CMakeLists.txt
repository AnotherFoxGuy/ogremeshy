#-------------------------------------------------------------------
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------
cmake_minimum_required(VERSION 3.10)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/" ${CMAKE_MODULE_PATH})

include(CMakeDependentOption)
include(Macros)
include(FeatureSummary)

project(OgreMeshy VERSION 1.11)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
#set(CMAKE_CXX_STANDARD 14)

#set(MESHY_USE_RTSS TRUE CACHE BOOL "use RTSS")
set(MESHY_USE_RTSS FALSE)

set(_PREFIX "OM_")

# Test if conan is installed
find_program(CONAN_CMD_TEST conan NO_CACHE)
cmake_dependent_option(USE_PACKAGE_MANAGER "Use conan" ON "NOT CONAN_CMD_TEST STREQUAL CONAN_CMD_TEST-NOTFOUND" OFF)
message(STATUS "Using conan: ${USE_PACKAGE_MANAGER}")

# Allow user to globally set the library preference for external libraries
cmd_option(${_PREFIX}LIB_PREFERENCE
        "Library preference [SYSTEM (if available), CONAN]"
        "CONAN"
        STRINGS "SYSTEM" "CONAN"
        )

# Special mode, that will force dependencies to the packages provided by system unless they were set to conan explicitly.
option(${_PREFIX}FORCE_SYSTEM_DEPENDENCIES "Force the use of system packages")


################################################################################
# Check for dependencies
################################################################################
include(DependenciesConfig)
resolve_conan_dependencies()


if (UNIX)
    find_package(GTK2 REQUIRED gtk)
endif ()

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
    set(SOURCES ${SOURCES}  "${CMAKE_SOURCE_DIR}/resources/Resource.rc")
endif ()

add_executable(${PROJECT_NAME} WIN32 ${SOURCES} ${HEADERS})

target_link_libraries(${PROJECT_NAME} PRIVATE OGRE::OGRE wxWidgets::wxWidgets)

if (UNIX)
    include_directories(${GTK2_INCLUDE_DIRS})
    add_definitions(${GTK2_DEFINITIONS})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${GTK2_LIBRARIES})
endif ()

if(MESHY_USE_RTSS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE MESHY_USE_RTSS)
endif()

configure_file(${CMAKE_SOURCE_DIR}/CMake/Templates/Plugins.cfg.in ${CMAKE_BINARY_DIR}/bin/plugins.cfg)

fast_copy("${CMAKE_SOURCE_DIR}/resources/Fonts" "${RUNTIME_OUTPUT_DIRECTORY}/resources/Fonts")
fast_copy("${CMAKE_SOURCE_DIR}/resources/Icons" "${RUNTIME_OUTPUT_DIRECTORY}/resources/Icons")
fast_copy("${CMAKE_SOURCE_DIR}/resources/Other" "${RUNTIME_OUTPUT_DIRECTORY}/resources/Models")
fast_copy("${CMAKE_SOURCE_DIR}/resources/Models" "${RUNTIME_OUTPUT_DIRECTORY}/resources/Models")
#fast_copy("${CMAKE_SOURCE_DIR}/resources/RTShaderLib" "${RUNTIME_OUTPUT_DIRECTORY}/resources/RTShaderLib")


#  Install targets
# -----------------------
install(TARGETS ${PROJECT_NAME} DESTINATION .)

install(DIRECTORY ${CMAKE_SOURCE_DIR}/resources/Fonts DESTINATION resources)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/resources/Icons DESTINATION resources)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/resources/Other/ DESTINATION resources/Models)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/resources/Models DESTINATION resources)
#install(DIRECTORY ${CMAKE_SOURCE_DIR}/resources/RTShaderLib DESTINATION resources)

if (WIN32)
    install(FILES ${CMAKE_BINARY_DIR}/bin/plugins.cfg DESTINATION .)
    install(CODE "file(GLOB files ${RUNTIME_OUTPUT_DIRECTORY}/*.dll)
            file(INSTALL \${files} DESTINATION \${CMAKE_INSTALL_PREFIX})")
endif ()


include(FeatureSummary)
feature_summary(WHAT ALL)
