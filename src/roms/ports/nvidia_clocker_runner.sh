#!/bin/bash
function constants() {
    export DISPLAY=:0.0
    source /userdata/roms/ports/.data/nvidia_clocker/config.sh
}

# provide xterm copy in /tmp
prerequisites() {
    cp $(which xterm) $XTERM_TMP_FILE && chmod 777 $XTERM_TMP_FILE
}

function main() {
    constants
    prerequisites

    # export DISPLAY
    export DISPLAY=:0.0

    # open xterm with DISPLAY output and run nvidia_clocker.sh with according parameters
    DISPLAY=:0.0 $XTERM_TMP_FILE -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c " \
    echo -e \"#################### ABOUT TO ADJUST NVIDIA GPU CLOCKS ####################\"; \
    sleep 1; \
    
    echo -e \"\nCLEANING UP OLD LOGS:\"; \
    echo -e -n \"$($BASEDIR/nvidia_clocker.sh cleanup_old_logs)\"; \
    echo -e \"${WHITE}DONE \xE2\x9C\x94\";
    sleep 1; \
    
    echo -e \"\nPRINTING FACTS:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocker.sh print_config)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}CONFIG CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}CHECKING NVIDIA-SMI\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocker.sh check_smi)\"; \
    if [ $? == 1 ]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}NVIDIA-SMI CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}TRYING TO DETECT INSTALLED NVIDIA GPU TYPE\"; \
    echo -e \"$($BASEDIR/nvidia_clocker.sh check_gpu_type)\"; \
    if [ $? == 1 ]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}GPU CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}FINALLY ATTEMPTING TO CLOCK GPU\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/nvidia_clocker.sh clock_gpu)\"; \
    if [ $? == 1 ]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \ 
    else echo -e \"${WHITE}GPU CLOCKING DONE \xE2\x9C\x94 \n\"; fi ; \
    
    echo -e \"${WHITE}PRINTING CLOCKING LOGS\"; \
    cat $NVIDIA_SMI_LGC_LOG; \
    sleep 3;
    echo -e \"\n${WHITE}PRINTING CURRENT GPU CLOCKS\"
    cat $NVIDIA_SMI_CLOCKS_LOG; \
    sleep 3; \

    echo -e \"\n${WHITE}#################### DONE ####################\"
    sleep 5; \
    exit 0
    "
}

main "$@"
