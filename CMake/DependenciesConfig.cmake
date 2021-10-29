include(DependenciesFunctions)

# Some pkg-config files are broken, that is why they are commented out

add_external_lib(
        OGRE
        ogre3d/1.11.6.1@anotherfoxguy/stable
        CONAN_PKG_NAME OGRE
        REQUIRED
        # PKG_CONFIG "OGRE = 1.11.6"
        FIND_PACKAGE_OPTIONS 1.11 COMPONENTS Bites Overlay Paging RTShaderSystem MeshLodGenerator Terrain
)

add_external_lib(
        wxwidgets
        wxwidgets/3.1.5@bincrafters/stable
        REQUIRED
        PKG_CONFIG "openal >= 1.18"
        FIND_PACKAGE_OPTIONS CONFIG
)
