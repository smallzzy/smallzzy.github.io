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

## device tree

* [Reference](https://docs.zephyrproject.org/latest/guides/dts/intro.html)
* tree struct starts from `/ {}`
* each node is named like `node_label: node_name`
  * node_label is optional
  * node_label is a shorthand to help being referenced
  * the address in node name serve no use?
* node property
  * `compatible`: specify driver to be used
  * `label`: can be used in `device_get_binding()`
  * identify child node
    * `#address-cells`, `#size-cells`
    * `reg` in child node
  * `interrupts` ?
* device tree has no contraint over its content
  * `dts/bindings`: force tree structure
  * `dt_schema` ?

### device access

* get node id
  * `DT_PATH()`: from tree path
  * `DT_NODELABEL()`: from node_label
  * `DT_ALIAS()`: from `/aliases`
  * `DT_INST()`: get one compatible device via its instance number
    * order of instance is not guaranteed
* get node label
  * `DT_LABEL`

### device driver

* config: build time configuration
* data: driver data
* api: sub system api

## todo

user mode
threads
optimization
