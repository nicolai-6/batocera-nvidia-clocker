#!/bin/bash

function constants() {
    source /userdata/roms/ports/.data/nvidia_clocker/config.sh
}

# print desired values that script expects
print_infos() {
    echo -e "${GREEN}EXPECTED GPU TYPE: $EXPECTED_GPU_TYPE"
    sleep 1
    echo -e "${GREEN}DESIRED MIN CLOCK SPEED: $GPU_CLOCK_MIN"
    sleep 1
    echo -e "${GREEN}DESIRED MAX CLOCK SPEED: $GPU_CLOCK_MAX"
    sleep 2
}

# check if nvidia-smi binary exists
is_nvidia_smi_present() {
    if [ -e $NVIDIA_SMI ]
    then
        echo -e "${GREEN}NVIDIA-SMI FOUND IN: $NVIDIA_SMI"
        sleep 2
        exit 0
    else
        echo -e "${RED}NVIDIA SMI NOT FOUND IN: $NVIDIA_SMI"
        sleep 2
        echo -e "${RED}Aborting..."
        sleep 2
        exit 1
    fi
}

# detect nvidia gpu_type (currently not supporting multiple gpus)
check_gpu_type() {
    DETECTED_GPU_TYPE=$($NVIDIA_SMI --query-gpu=gpu_name --format=csv,noheader)
    echo -e "${BLUE}DETECTED GPU TYPE: $DETECTED_GPU_TYPE"
    sleep 3
    exit 0
}

# adjust gpu clocks if gpu_type is correct
clock_gpu() {
    DETECTED_GPU_TYPE=$($NVIDIA_SMI --query-gpu=gpu_name --format=csv,noheader)

    if [[ $DETECTED_GPU_TYPE == $EXPECTED_GPU_TYPE ]]
    then
        echo -e "${GREEN}GPU TYPE CORRECT - CLOCKING NOW"
        sleep 3
        # for some reason if command is run normally the runner script crashes - so we redirect output to file
        $NVIDIA_SMI -lgc $GPU_CLOCK_MIN,$GPU_CLOCK_MAX > $NVIDIA_SMI_LGC_LOG
        sleep 1
        $NVIDIA_SMI --query-gpu=clocks.sm,clocks.gr --format=csv > $NVIDIA_SMI_CLOCKS_LOG
        sleep 1
        exit 0
    else
        echo -e "${RED}GPU TYPE NOT CORRECT - ABORTING"
        sleep 3
        exit 1
    fi
  sleep 1
}

function main() {
    # if script is run without parameter we quit
    if [ $# -eq 0 ]
    then
        echo "something went wront"
        exit 1
    fi

    # constants are always required
    constants

    # catch parameter and run according function only
    if [ $1 == "print_infos" ]
    then
        print_infos
    elif [ $1 == "check_smi" ]
    then
        is_nvidia_smi_present
    elif [ $1 == "check_gpu" ]
    then
        check_gpu_type
    elif [ $1 == "clock_gpu" ]
    then
        clock_gpu
    else
        echo "wrong parameter"
        exit 1
    fi
}

main "$@"
