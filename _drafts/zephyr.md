## install zephyr

* follow getting start guide
* setup workspace path
  * `source zephyr-env.sh`
* [out of tree definition](https://docs.zephyrproject.org/latest/application/index.html#custom-board-definition)
  * `west ... -- -DBOARD_ROOT=<parent of boards folder>`

## Kconfig

* [Reference](https://docs.zephyrproject.org/latest/guides/kconfig/setting.html#the-initial-configuration)
* build/zephyr/.config is generated based on the following sources
  * board config `<BOARD>_defconfig`
  * CMAKE cache `CONFIG_`
  * application conf file: `prj.conf` and etc

### board porting

* [Reference](https://docs.zephyrproject.org/latest/guides/porting/board_porting.html#write-kconfig-files)
* `Kconfig.board`
  * define options in menuconfig
* board specific kconfig defaults
  * `Kconfig.defconfig`: invisible Kconfig symbols
    * cannot be overrided in .config
  * `<BOARD>_defconfig`: visible Kconfig symbols
