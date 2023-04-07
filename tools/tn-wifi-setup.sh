#!/bin/sh
#
# i.MX Yocto Project Build Environment Setup Script
#
# Copyright (C) 2011-2016 Freescale Semiconductor
# Copyright 2017 NXP
# Copyright 2020 TechNexion Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

MACHINE="$1"
TOKEN="$2"
WIFI_MODULE="$3"
WIFI_FIRMWARE="$4"

# extra variables for BB_ENV_PASSTHROUGH_ADDITIONS
if [ -n "$TOKEN" ]; then
  echo "Specified PA_TOKEN: $TOKEN"
  export PA_TOKEN=$TOKEN
  if ! grep -qF "PA_TOKEN" <<< $BB_ENV_PASSTHROUGH_ADDITIONS; then
    echo "Export PA_TOKEN=$TOKEN to yocto via BB_ENV_PASSTHROUGH_ADDITIONS"
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS PA_TOKEN"
  fi
fi

# corresponding firmware package for different WLAN (QCA or BRCM), e.g. 'linux-firmware-brcm-tn' or 'linux-firmware-qca-tn'
if [ -z "${WIFI_FIRMWARE#"${WIFI_FIRMWARE%%[! ]*}"}" ]; then
    echo "WARNING - No WIFI_FIRMWARE specified"
    RF_FIRMWARES=""
else
    # Identify SOC type
    CPU_TYPE=$(echo $MACHINE | sed 's/.*-\(imx[5-8][a-z]*\)[- $]*.*/\1/g')
    if [ "$WIFI_FIRMWARE" = "all" ]; then
        if [ "$CPU_TYPE" = "imx8mq" -o "$CPU_TYPE" = "imx8mm" -o "$CPU_TYPE" = "imx8mp" ]; then
            echo "WARNING - imx8mq/imx8mm/imx8mp SOM supports qca and nxp wireless modules, qca firmware by default"
            RF_FIRMWARES="qca ath-pci"
        elif [ "$CPU_TYPE" = "imx6" -o "$CPU_TYPE" = "imx7" -o "$CPU_TYPE" = "imx6ul" ]; then
            RF_FIRMWARES="qca brcm ath-pci"
        else
            echo "WARNING - No matched CPU_TYPE: $CPU_TYPE, hence no WIFI_FIRMWARE"
            RF_FIRMWARES=""
        fi
    elif [ "$WIFI_FIRMWARE" = "y" -o "$WIFI_FIRMWARE" = "Y" ]; then
        if  [ -z "${WIFI_MODULE#"${WIFI_MODULE%%[! ]*}"}" ]; then
            if [ "$CPU_TYPE" = "imx8mq" -o "$CPU_TYPE" = "imx8mm" -o "$CPU_TYPE" = "imx8mp" ]; then
                echo "WARNING - imx8mq/imx8mm/imx8mp SOM supports qca and nxp wireless modules, qca firmware by default"
                RF_FIRMWARES="qca"
            else
                echo "WARNING - No WIFI_MODULE specified."
                RF_FIRMWARES=""
            fi
        else
            RF_FIRMWARES=$WIFI_MODULE
        fi
    else
        echo "WARNING - Unrecognized WIFI_FIRMWARE specified"
        RF_FIRMWARES=""
    fi
fi
if [ -n "$RF_FIRMWARES" ]; then
  echo "Specified wifi firmwares: $RF_FIRMWARES"
  export RF_FIRMWARES=$RF_FIRMWARES
  if ! grep -qF "RF_FIRMWARES" <<< $BB_ENV_PASSTHROUGH_ADDITIONS; then
    echo "Export RF_FIRMWARES=$RF_FIRMWARES to yocto via BB_ENV_PASSTHROUGH_ADDITIONS"
    export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS RF_FIRMWARES"
  fi
fi
