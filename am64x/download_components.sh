#!/bin/bash
#
# Script to download and install Motor Control SDK baselined components
#

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
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
    -h|--help)
    echo Usage: $0 [options]
    echo
    echo Options
    echo "--motor_control_folder  Path to the Motor Control SDK folder. Default value is motor_control_sdk"
    echo "--install_dir          Path where the tools should be installed. Default value is "${HOME}/ti""
    echo "--skip_nodejs          Pass "--skip_nodejs=true" to skip nodejs installation. Default value is false."
    echo "--skip_doxygen         Pass "--skip_doxygen=true" to skip doxygen installation. Default value is false."
    exit 0
    ;;
esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

: ${motor_control_folder:="motor_control_sdk"}
: ${install_dir:="${HOME}/ti"}
: ${skip_nodejs:="false"}
: ${skip_doxygen:="false"}

release_version=09_00_00
product_family="am64x"
THIS_DIR=$(dirname $(realpath $0))
BASE_DIR=$(realpath ${THIS_DIR}/..)
script=${BASE_DIR}/releases/${release_version}/${product_family}/download_components.sh

#Reuse current release version download script
echo "Invoking ${script}"
${script} --motor_control_folder="${motor_control_folder}" --install_dir="${install_dir}" --skip_nodejs="${skip_nodejs}" --skip_doxygen="${skip_doxygen}"
