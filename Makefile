DEFINES = # -DWITH_GENERATED_DTSI
CPPFLAGS = -nostdinc -undef -x assembler-with-cpp
DTC = dtc
# Use quiet since the dtb file doesn't reserve memory, nor define regs or ranges.
DTCFLAGS = --sort --quiet
DTSI = generated.dtsi $(wildcard dts/*.dtsi)
FDTSHIM_MAPPING_GENERATOR = fdtshim-mapping-generator

all: mapping.dtb

clean:
	rm -v mapping.dtb
	rm -v mapping.dts
	rm -v generated.dtsi

.PHONY: all clean generated.dtsi

generated.dtsi:
	$(FDTSHIM_MAPPING_GENERATOR) $(KERNEL_DTBS) > $@ || rm $@

mapping.dts: Makefile ${DTSI}
	( \
		echo '/dts-v1/;'; \
		echo '#include "generated.dtsi"'; \
		find dts/ -type f | sort | sed -e 's/^/#include "/' -e 's/$$/"/' \
	) > $@

mapping.dtb: mapping.dts ${DTSI}
	cpp $(DEFINES) $(CPPFLAGS) $< | $(DTC) $(DTCFLAGS) > $@

final-mapping.dts: mapping.dtb
	$(DTC) $(DTCFLAGS) $< > $@
