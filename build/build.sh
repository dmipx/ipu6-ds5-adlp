#!/bin/bash
# This script follows this guide: https://rsconf.intel.com/display/SWMIPI/Compiling+IPU6+modules
#
# Build compatible only on ubuntu22, on other distributions you will get an error:
#scripts/basic/fixdep: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found (required by scripts/basic/fixdep)
#scripts/basic/fixdep: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by scripts/basic/fixdep)

# verbose script running
set -x
PWD=$(pwd)
# source of linux-headers-5.15.49-for-ubuntu_5.15.49-for-ubuntu-1_amd64.deb
PKG_PATH=${PWD}/../artifactory/
PKG=${PWD}/pkg
RESULTS=${PWD}/results/
IOTG_REPO="https://github.com/dmipx/ipu6-drivers.git"
IOTG_BRANCH="realsense_ipu6"
RS_IOTG_PATCH="https://github.com/IntelRealSense/d4xx_mipi_sensor_driver_adlp.git"

mkdir ${PKG} && cp ${PKG_PATH}/* ${PKG}
sudo dpkg -i ${PKG}/*.deb
rm -rf ${PKG}
git clone --depth 1 --branch ${IOTG_BRANCH} --single-branch ${IOTG_REPO}

cd ${PWD}/ipu6-drivers
#update uapi header
sudo cp include/uapi/linux/ipu-isys.h /usr/src/linux-headers-5.15.49-for-ubuntu/include/uapi/linux/ipu-isys.h

#build modules
make -j -C /usr/src/linux-headers-5.15.49-for-ubuntu/ M=$(pwd)

mkdir -p ${RESULTS}

# copy artifacts
cp ${PWD}/ipu6-drivers/drivers/media/i2c/d4xx.ko ${RESULTS}
cp ${PWD}/ipu6-drivers/drivers/media/i2c/max9295.ko ${RESULTS}
cp ${PWD}/ipu6-drivers/drivers/media/i2c/max9296.ko ${RESULTS}
cp ${PWD}/ipu6-drivers/drivers/media/pci/intel/ipu6/intel-ipu6-isys.ko ${RESULTS}
