#!/bin/bash
#
# Script to download and install current baselined components
#

install_win_package_on_linux="false"
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --install_win_package_on_linux)
    install_win_package_on_linux="true"
    shift # past argument
    ;;
    --motor_control_folder=*)
    motor_control_folder="${1#*=}"
    shift # past argument
    ;;
    --install_dir=*)
    install_dir="${1#*=}"
    shift # past argument
    ;;
    --skip_nodejs=*)
    skip_nodejs="${1#*=}"
    shift # past argument
    ;;
    --skip_doxygen=*)
    skip_doxygen="${1#*=}"
    shift # past argument
    ;;
    --skip_ccs=*)
    skip_ccs="${1#*=}"
    shift # past argument
    ;;
    -h|--help)
    echo Usage: $0 [options]
    echo
    echo Options
    echo --install_win_package_on_linux Used to install windows packages in linux environment for release packaging
    exit 0
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
THIS_DIR=$(dirname $(realpath $0))
BASE_DIR=${THIS_DIR}/../../..
COMPONENT_DIR=${BASE_DIR}/../..
: ${motor_control_folder:="motor_control_sdk"}
: ${install_dir:="${HOME}/ti"}
: ${skip_nodejs:="false"}
: ${skip_doxygen:="false"}
: ${skip_ccs:="false"}

#Source common component versions
source ${THIS_DIR}/../.component_versions
source ${BASE_DIR}/scripts/common.sh

if [ "$install_win_package_on_linux" == "true" ]; then
    echo "Installing windows packages on linux machine...."
    #Nothing yet!!
fi

clang_url_folder="${CGT_TI_ARM_CLANG_VERSION}.${CGT_TI_ARM_CLANG_VERSION_SUFFIX}"
clang_install_folder="ti-cgt-armllvm_${CGT_TI_ARM_CLANG_VERSION}.${CGT_TI_ARM_CLANG_VERSION_SUFFIX}"
clang_install_file="ti_cgt_armllvm_${CGT_TI_ARM_CLANG_VERSION}.${CGT_TI_ARM_CLANG_VERSION_SUFFIX}_linux-x64_installer.bin"

# MCU + SDK
mcu_plus_sdk_url=${MCU_PLUS_SDK_AM263X_RELEASE_URL}
mcu_sdk_version="${MCU_PLUS_SDK_AM263X}"

# IND COMMS SDK
ind_comms_sdk_url="${IND_COMMS_SDK_AM263X_RC_URL}"
ind_comms_sdk_version="${IND_COMMS_SDK_AM263X}"

platform="am263x"

if [ "${OS}" = "Windows_NT" ]; then
    echo "Installing windows packages"
    #TODO
else
    if [ "$skip_ccs" == "false" ]; then
        install_ccs     ${CCS_VERSION} ${install_dir}
    fi
    #install_clang   ${CGT_TI_ARM_CLANG_VERSION} ${clang_url_folder} ${clang_install_folder} ${clang_install_file} ${install_dir}
    install_syscfg  ${SYSCFG_VERSION} ${install_dir}
    install_mcu_plus_sdk  ${mcu_sdk_version} ${platform} ${motor_control_folder} ${mcu_plus_sdk_url}
    install_ind_comms_sdk  ${ind_comms_sdk_version} ${platform} ${motor_control_folder} ${ind_comms_sdk_url}
    if [ "$skip_nodejs" == "false" ]; then
        install_nodejs  ${NODEJS_VERSION} ${motor_control_folder}
    fi
    if [ "$skip_doxygen" == "false" ]; then
        install_doxygen ${DOXYGEN_VERSION}
    fi
    ccs_discover_tools  ${CCS_VERSION} ${install_dir}
fi

#
# PC OS agnostic installer packages
#
#None
