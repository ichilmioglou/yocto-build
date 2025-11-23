SUMMARY = "Simple Hello World CMake app"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://CMakeLists.txt \
    file://main.cpp \
"

S = "${WORKDIR}"

inherit cmake

do_install:append() {
    # CMake will install into ${D}. Nothing extra needed.
    :
}
