#!/bin/bash
CONFIG_FILE=/userdata/roms/ports/.data/nvidia_clocker/config.sh

function constants() {
    if [[ -e $CONFIG_FILE ]]
    then
        source $CONFIG_FILE
        return 0
    else
        echo -e "${RED}$CONFIG_FILE does not exist"
        sleep 2
        return 1
    fi
}

function cleanup_old_logs() {
    rm -f $NVIDIA_SMI_LGC_LOG
    rm -f $NVIDIA_SMI_CLOCKS_LOG
    return 0
}

# print desired values that script expects
function print_config() {
    if [[ -z $EXPECTED_GPU_TYPE ]] || [[ -z $GPU_CLOCK_MIN ]] || [[ -z $GPU_CLOCK_MAX ]]
    then
        echo -e "${RED}at least one mandatory value has not been set in $CONFIG_FILE"
        sleep 2
        return 1
    else
        echo -e "${GREEN}EXPECTED GPU TYPE: $EXPECTED_GPU_TYPE"
        sleep 2
        echo -e "${GREEN}DESIRED MIN CLOCK SPEED: $GPU_CLOCK_MIN"
        sleep 2
        echo -e "${GREEN}DESIRED MAX CLOCK SPEED: $GPU_CLOCK_MAX"
        sleep 2
        return 0
    fi
}

# check if nvidia-smi binary exists
function check_smi() {
    if [[ -e $NVIDIA_SMI ]]
    then
        echo -e "${GREEN}NVIDIA-SMI FOUND IN: $NVIDIA_SMI"
        sleep 2
        return 0
    else
        echo -e "${RED}NVIDIA SMI NOT FOUND IN: $NVIDIA_SMI"
        sleep 2
        return 1
    fi
}

# detect nvidia gpu_type (currently not supporting multiple gpus)
function check_gpu_type() {
    DETECTED_GPU_TYPE=$($NVIDIA_SMI --query-gpu=gpu_name --format=csv,noheader)

    if [[ -z $DETECTED_GPU_TYPE ]]
    then
        echo -e "${RED}GPU could not be detected"
        sleep 2
        return 1
    else
        echo -e "${BLUE}DETECTED GPU TYPE: $DETECTED_GPU_TYPE"
        sleep 2
        return 0
    fi
}

# adjust gpu clocks if gpu_type is correct
function clock_gpu() {
    DETECTED_GPU_TYPE=$($NVIDIA_SMI --query-gpu=gpu_name --format=csv,noheader)

    if [[ $DETECTED_GPU_TYPE == $EXPECTED_GPU_TYPE ]]
    then
        echo -e "${GREEN}GPU TYPE IS CORRECT - CLOCKING NOW"
        sleep 2
        # for some reason if command is run normally the runner script crashes - so we redirect output to file
        $NVIDIA_SMI -lgc $GPU_CLOCK_MIN,$GPU_CLOCK_MAX > $NVIDIA_SMI_LGC_LOG
        sleep 2
        $NVIDIA_SMI --query-gpu=clocks.sm,clocks.gr --format=csv > $NVIDIA_SMI_CLOCKS_LOG
        sleep 2
        return 0
    else
        echo -e "${RED}GPU TYPE NOT CORRECT"
        sleep 2
        return 1
    fi
}

function main() {
    # if script is run without parameter we quit
    if [[ $# -eq 0 ]]
    then
        echo "something went wront"
        return 1
    fi

    # constants is always run
    constants

    # catch parameter and run according function only
    if [[ $1 == "cleanup_old_logs" ]]
    then
        cleanup_old_logs
    elif [[ $1 == "print_config" ]]
    then
        print_config
    elif [[ $1 == "check_smi" ]]
    then
        check_smi
    elif [[ $1 == "check_gpu_type" ]]
    then
        check_gpu_type
    elif [[ $1 == "clock_gpu" ]]
    then
        clock_gpu
    else
        echo "wrong parameter"
        return 1
    fi
}

main "$@"
