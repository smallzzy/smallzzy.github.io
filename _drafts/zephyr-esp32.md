# install zephyr

## install

* esp idf -- sdk
* esp32 elf -- toolchain
* git clone zephyr
* zephyr sdk

## python requirement

* esp idf : /doc
* zephyr

## set path

zephyr-env.sh

set idf_path
add_path.sh

### use esp provided toolchain

export ZEPHYR_TOOLCHAIN_VARIANT="espressif"
export ESP_IDF_PATH="/home/smallzzy/develop/rtos/esp32/esp-idf"
export ESPRESSIF_TOOLCHAIN_PATH="/home/smallzzy/develop/rtos/esp32/xtensa-esp32-elf"

### use zephyr provided toolchain - the esp32 toolchain seems broken

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR=<sdk installation directory>

## run command
cmake -GNinja -DBOARD=esp32 -DESP_IDF_PATH=/home/smallzzy/develop/rtos/esp32/esp-idf ../..

ninja build


## update idf version

cd $IDF_PATH
git fetch
git checkout vX.Y.Z
git submodule update --init --recursive

## set esp device

http://docs.zephyrproject.org/boards/xtensa/esp32/doc/esp32.html

Variable	Default value
ESP_DEVICE	/dev/ttyUSB0
ESP_BAUD_RATE	921600 -- upload baud rate, 921600 is the fastest
ESP_FLASH_SIZE	detect
ESP_FLASH_FREQ	40m -- 
ESP_FLASH_MODE	dio
ESP_TOOL	espidf