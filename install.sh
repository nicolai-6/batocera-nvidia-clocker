#!/bin/bash

method_counter=0

function check_architecture() {
    if [ $(uname -m) != "x86_64" ]
    then
        echo "architecture check failed - this is not a x86_64 based system - aborting"
        exit 1
    fi
}

function constants() {
    REPO_URL="https://github.com/nicolai-6/batocera-nvidia-clocker/archive/refs/heads/main.zip"
    ARTIFACT_TMP_PATH=/tmp/batocera-nvidia-clocker.zip
    ARTIFACT_EXTRACTED_TMP_PATH="/tmp/batocera-nvidia-clocker-main/src/roms/ports/data/nvidia_clocker"
    TARGET_BASEDIR="/userdata/roms/ports"
}

function download_artifact() {
    echo "############ Trying to download repo content ############"
    wget -q --no-check-certificate --no-cache --no-cookies -O "$ARTIFACT_TMP_PATH" "$REPO_URL"
    if [ $? -ne 0 ]
    then
        echo "Downloading repo content failed - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function extract_artifact() {
    echo "############ Extracting zip archive ############"
    unzip -qq -o $ARTIFACT_TMP_PATH
    if [ $? -ne 0 ]
    then
        echo "Extracting the archive went wrong - aborting"
        exit 1
    fi
    
    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function setup() {
    # create dir
    echo "############ Creating $TARGET_BASEDIR/.data/nvidia_clocker dir ############"
    mkdir -p $TARGET_BASEDIR/.data/nvidia_clocker

    if [ $? -ne 0 ]
    then
        echo "Could not create $TARGET_BASEDIR/.data/nvidia_clocker dir - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1

    echo "############ copying required files ############"
    # provide image
    cp $ARTIFACT_EXTRACTED_TMP_PATH/roms/ports/images/nvidia_clocker.png $TARGET_BASEDIR/images/

    if [ $? -ne 0 ]
    then
        echo "copying the image failed - but we continue with installation anyway"
        exit 0
    fi

    # provide .data scripts
    cp $ARTIFACT_EXTRACTED_TMP_PATH/roms/ports/data/nvidia_clocker/config.sh $TARGET_BASEDIR/.data/nvidia_clocker/

    if [ $? -ne 0 ]
    then
        echo "copying the config file went wrong - aborting"
        exit 1
    fi

    cp $ARTIFACT_EXTRACTED_TMP_PATH/roms/ports/data/nvidia_clocker/nvidia_clocker.sh $TARGET_BASEDIR/.data/nvidia_clocker/

    if [ $? -ne 0 ]
    then
        echo "copying nvidia_clocker.sh went wrong - aborting"
        exit 1
    fi

    # provide nvidia-smi
    cp $ARTIFACT_EXTRACTED_TMP_PATH/roms/ports/data/nvidia_clocker/nvidia-smi $TARGET_BASEDIR/.data/nvidia_clocker/

    if [ $? -ne 0 ]
    then
        echo "copying nvidia-smi failed - aborting"
        exit 1
    fi

    # provide the ports runner script
    cp $ARTIFACT_EXTRACTED_TMP_PATH/roms/ports/nvidia_clocker_runner.sh $TARGET_BASEDIR/

    if [ $? -ne 0 ]
    then
        echo "copying runnerscript failed - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function cleanup() {
    echo "############ finally cleaning up ############"
    rm -rf $ARTIFACT_TMP_PATH
    rm -rf ${ARTIFACT_TMP_PATH::-4}-main

    if [ $? -ne 0 ]
    then
        echo "cleaning up resource went wrong - installation could be ok anyway"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function main() {
    
    for method in {check_architecture,constants,download_artifact,extract_artifact,setup,cleanup}
    do
        $method
        ((method_counter++))
    done

    if [[ $method_counter < 6 ]]
    then
        echo "not all required methods have been run - ABORTING"
        exit 1
    else
        echo "installation successful"
        echo "adjust $TARGET_BASEDIR/.data/nvidia_clocker/config.sh to fit your needs"
        exit 0
    fi
}

main "$@"
