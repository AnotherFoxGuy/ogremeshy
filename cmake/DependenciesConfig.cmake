include(DependenciesFunctions)

# Some pkg-config files are broken, that is why they are commented out

add_external_lib(
        OGRE
        ogre3d/1.11.6.1@anotherfoxguy/stable
        CONAN_PKG_NAME OGRE
        REQUIRED
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