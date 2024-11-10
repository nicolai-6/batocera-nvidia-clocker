#!/bin/bash

#### adjust your GPU data here ####
GPU_CLOCK_MIN=1500
GPU_CLOCK_MAX=1500
EXPECTED_GPU_TYPE="NVIDIA RTX A2000 12GB"
DETECTED_GPU_TYPE="" # normally kept blank

#### colors
WHITE='\033[0;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'

#### dependencies
XTERM_TMP_FILE="/tmp/xterm_runner"
BASEDIR="/userdata/roms/ports/.data/nvidia_clocker"
NVIDIA_SMI="$BASEDIR/nvidia-smi"
NVIDIA_SMI_LGC_LOG="$BASEDIR/nvidia_smi_lgc.log"
NVIDIA_SMI_CLOCKS_LOG="$BASEDIR/nvidia_smi_clocks.log"
