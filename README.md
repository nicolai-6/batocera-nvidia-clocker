# batocera-nvidia-clocker

## Providing a tiny nvidia-smi wrapper script to make nvidia GPU clock adjustments
### facts
* can be run from batocera terminal, SSH or via emulationstation ports section
* only tested on batocera v39, v40 and v41
* limited to x86_x64
* shipping x86_x64 nvidia-smi version 560.35.03
* changes made to clock speeds are NOT permanent and will be reverted with every batocera shutdown / reboot
* default config.sh hard limits a NVIDIA RTX A2000 12GB GPU clock speeds to 1500 (min and max) - see the modify instruction to adjust it to your needs

### Install
* make sure batocera has properly loaded nvidia-driver
* make sure your internet connection is working
* run two terminal commands from batocera (F1->applications->xterm) or via SSH to install it

    ```
    curl -o /tmp/install.sh https://raw.githubusercontent.com/nicolai-6/batocera-nvidia-clocker/refs/heads/main/install.sh
    bash /tmp/install.sh
    ```

### modify
* after initial setup adjust /userdata/roms/ports/.data/nvidia_clocker/config.sh
* normally you only want to adjust three values here

    ``` GPU_CLOCK_MIN=1500 ```

    ``` GPU_CLOCK_MAX=1500 ```

    ``` EXPECTED_GPU_TYPE="NVIDIA RTX A2000 12GB" ```

* to properly fill in ``` EXPECTED_GPU_TYPE ``` query your GPU with nvidia-smi

    ```/userdata/roms/ports/.data/nvidia_clocker/nvidia-smi --query-gpu=gpu_name --format=csv,noheader```

### run it
* update batocera gamelists (GAME SETTINGS > UPDATE GAMELISTS)
* Run from Emulationstation:
    * navigate to PORTS and run ``` NVIDIA GPU Clocker ```
* Run from terminal:
    * /userdata/roms/ports/nvidia_clocker_runner.sh

### appendix
* Manual cleanup via terminal
    * remove /userdata/roms/ports/nvidia_clocker_runner.sh
    * remove /userdata/roms/ports/.data/nvidia_clocker directory
    * remove from Ports gamelist either via emulationstation or gamelist.xml

</br>
## HAPPY CLOCKING
