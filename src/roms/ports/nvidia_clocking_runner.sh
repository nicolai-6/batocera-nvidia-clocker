#!/bin/bash

function constants() {
    export DISPLAY=:0.0
    source /userdata/roms/ports/.data/nvidia_clocking/config.sh
}

# provide xterm copy in /tmp
prerequisites() {
    cp $(which xterm) $XTERM_TMP_FILE && chmod 777 $XTERM_TMP_FILE
}

function main() {
    constants
    prerequisites

    # open xterm with DISPLAY output and run nvidia_clocking.sh with according parameters
    DISPLAY=:0.0 $XTERM_TMP_FILE -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c \
    " \
    echo -e \"#################### ABOUT TO ADJUST NVIDIA GPU CLOCKS #################### \"; \
    sleep 1; \
    echo -e \"\nPRINTING FACTS:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocking.sh print_infos) \";
    sleep 3; \

    echo -e \"\n${WHITE}CHECK IF NVIDIA-SMI IS PRESENT\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocking.sh check_smi) \"; \
    if [ $? == 1 ]; then exit 1; else echo -e \"${WHITE}NVIDIA-SMI CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}TRYING TO DETECT INSTALLED NVIDIA GPU TYPE\"; \
    echo -e \"$($BASEDIR/nvidia_clocking.sh check_gpu) \"; \
    if [ $? == 1 ]; then exit 1; else echo -e \"${WHITE}GPU CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}FINALLY ATTEMPT TO CLOCK GPU\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocking.sh clock_gpu) \"; \
    if [ $? == 1 ]; then exit 1; else echo -e \"${WHITE}GPU CLOCKING DONE \xE2\x9C\x94 \n\"; fi ; \
    
    cat $NVIDIA_SMI_LGC_LOG; \
    echo -e \"\n${WHITE}READ CURRENT GPU CLOCKS \"
    cat $NVIDIA_SMI_CLOCKS_LOG; \
    sleep 3; \

    echo -e \"\n${WHITE}#################### DONE #################### \"
    sleep 8; \
    "
}

main "$@"
