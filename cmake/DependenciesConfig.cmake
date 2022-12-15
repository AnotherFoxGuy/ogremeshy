include(DependenciesFunctions)

if (USE_PACKAGE_MANAGER)

    conan_add_remote(
            NAME ror-conan
            URL https://git.anotherfoxguy.com/api/packages/rorbot/conan
            VERIFY_SSL True
    )
    conan_add_remote(
            NAME bincrafters-artifactory
            URL https://bincrafters.jfrog.io/artifactory/api/conan/public-conan
            VERIFY_SSL True
    )

    #execute_process(COMMAND ${CONAN_CMD} config get "general.revisions_enabled" OUTPUT_VARIABLE conan_revisions_enabled)
    # if("${conan_revisions_enabled}" EQUAL "0")
    #     message("Setting conan revisions_enabled to 1")
    #    execute_process(COMMAND ${CONAN_CMD} config set "general.revisions_enabled=1")
    #endif()
endif ()

# Some pkg-config files are broken, that is why they are commented out

add_external_lib(
        OGRE
        ogre3d/1.11.6.1@anotherfoxguy/stable
        REQUIRED
        # PKG_CONFIG "OGRE = 1.11.6"
        FIND_PACKAGE_OPTIONS 1.11 COMPONENTS Bites Overlay Paging RTShaderSystem MeshLodGenerator Terrain
)

add_external_lib(
        wxWidgets
        wxwidgets/3.1.5@bincrafters/stable
        REQUIRED
        FIND_PACKAGE
)

add_external_lib(
        zlib
        zlib/1.2.12
)

add_external_lib(
        libtiff
        libtiff/4.4.0
)

add_external_lib(
        libpng
        libpng/1.6.37
)