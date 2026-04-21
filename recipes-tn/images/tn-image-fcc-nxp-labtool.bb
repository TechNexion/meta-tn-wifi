# Copyright (C) 2015 Freescale Semiconductor
# Copyright 2017-2018 NXP
# Copyright (C) 2026 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)
#
# 1. Configuration example for setup script:
#    TOKEN=XXXxxxXXXX WIFI_FIRMWARE=y DISTRO=fsl-imx-wayland MACHINE=edm-g-imx8mp source tn-setup-release.sh -b build-wayland-edm-g-imx8mp
# 2. Add DISTRO_FEATURES:append = " fcc-nxp-labtool-imx" into conf/local.conf
# 3. bitbake tn-image-fcc-nxp-labtool
#

DESCRIPTION = "Freescale Image to validate i.MX machines. \
This image contains everything used to test i.MX machines including CLI-GUI, \
demos and lots of applications. This creates a very large image, not \
suitable for production."
LICENSE = "MIT"

inherit core-image

### WARNING: This image is NOT suitable for production use and is intended
###          to provide a way for users to reproduce the image used during
###          the validation process of i.MX BSP releases.

#inherit extrausers
#EXTRA_USERS_PARAMS = "usermod -P root root;"

## Select Image Features
IMAGE_FEATURES += " \
    ssh-server-dropbear \
"

IMAGE_INSTALL:remove = " \
    packagegroup-base-extended \
    packagegroup-tn-nfc \
    packagegroup-tn-tools \
    packagegroup-tn-voicehat \
    packagegroup-tn-wlan \
    get-support-info \
    tn-apt-list \
    vizionsdk-dev \
    vizionviewer \
"

IMAGE_INSTALL:append = " \
    packagegroup-tn-fcc-nxp-wlan \
    nxp-labtool-imx \
"
