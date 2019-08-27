#-------------------------------------------------------------------
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------

macro( setupInstallers )

INSTALL(
        DIRECTORY ${RUNTIME_OUTPUT_DIRECTORY}/
        DESTINATION ./
        USE_SOURCE_PERMISSIONS
        PATTERN "*.lib" EXCLUDE
)


# CPack
set(CPACK_PACKAGE_DESCRIPTION "OgreMeshy")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Ogre Meshy is a tool for viewing OGRE mesh files.")
set(CPACK_PACKAGE_CONTACT "Edgar@AnotherFoxGuy.com")
set(CPACK_PACKAGE_VENDOR "AnotherFoxGuy")
SET(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
SET(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE.txt")
# packaging needs WiX Tooset installed
# Upgrade Code must always be the same, so the setup can replace the existing installation
set(CPACK_WIX_UPGRADE_GUID "71d983c4-2eec-4df5-9114-9a55e1f1b138")
set(CPACK_WIX_CMAKE_PACKAGE_REGISTRY ${PROJECT_NAME})
set(CPACK_WIX_PROGRAM_MENU_FOLDER "${PROJECT_NAME}")
set(CPACK_STRIP_FILES ON)

#For Windows Start Menu entries
set(CPACK_PACKAGE_EXECUTABLES
  "${PROJECT_NAME}" "${PROJECT_NAME}"
)

#For Windows Desktop shortcuts
set(CPACK_CREATE_DESKTOP_LINKS "${PROJECT_NAME}" "${PROJECT_NAME}" )

# Windows Add or Remove Program properties
set(CPACK_WIX_PROPERTY_ARPCOMMENTS "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
set(CPACK_WIX_PROPERTY_ARPHELPLINK "https://github.com/AnotherFoxGuy/ogremeshy")
set(CPACK_WIX_PROPERTY_ARPURLINFOABOUT "https://github.com/AnotherFoxGuy/ogremeshy")
set(CPACK_WIX_PROPERTY_URLUPDATEINFO "https://github.com/AnotherFoxGuy/ogremeshy")

IF (MSVC)
    set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
    SET(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${PROJECT_VERSION}")
    SET(CPACK_GENERATOR ZIP;WIX)
		SET(CPACK_MODULE_PATH "")
ENDIF (MSVC)

include(CPack)
endmacro()
