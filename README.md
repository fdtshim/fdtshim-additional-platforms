`fdtshim-additional-platforms`
==============================

This repository holds additional knowledge related to loading the *correct* dtb file from non-dtb environments.

As of now, this is used to describe ACPI platforms that require loading a *correct*[sic] dtb file.

This project, coupled with `fdtshim-mapping-generator` should be part of the build pipeline for the kernel of your system.
This allows ensuring the mapping is proper for a given kernel build.


Usage
-----

```
 $ make KERNEL_DTBS=.../path/to/dtbs
 $ file mapping.dtb 
mapping.dtb: Device Tree Blob version 17, size=127109, boot CPU=0, string block size=89, DT structure block size=126964
```

You can peer at the generated source with the handy `final-mapping.dts` target

```
 $ make final-mapping.dts KERNEL_DTBS=.../path/to/dtbs
 $ file final-mapping.dts 
final-mapping.dts: Device Tree File (v1), ASCII text
 $ head final-mapping.dts 
/dts-v1/;

/ {
        compatible = "fdtshim,mapping";
        fdtshim,generator = "fdtshim-mapping-generator";
        fdtshim,schema-version = "0.1";

        mapping {

                actions@s700-cubieboard7 {
```


Requirements
------------

 - [`fdtshim-mapping-generator`](https://github.com/fdtshim/fdtshim-mapping-generator)
 - [`dtc`](https://github.com/dgibson/dtc)

And

 - `find`
 - `sort`
 - `sed`


Contributing boards
-------------------

The data is authored within files, separated per SoC.

The filename is the prefix from the kernel dtb names; the part before the vendor name.

Examples:

```
amlogic/meson-gxl-s905x-libretech-cc.dtb
        meson-gxl-s905x
        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

realtek/rtd1295-mele-v9.dtb
        rtd1295
        ¯¯¯¯¯¯¯

rockchip/rk3399-rock-pi-4b.dtb
         rk3399
         ¯¯¯¯¯¯
```

Only the data that is not generated by `fdtshim-mapping-generator` needs to be added.

The files are included in alphabetical order.

The content should be sorted in alphabetical order (by node name), but an exception is allowed for matching variants first.

Please add the output of `grep . /sys/class/dmi/id/*` ran from the device as comments when adding devices.
This will allow maintainers to improve the precision of the mapping without owning the devices themselves.
