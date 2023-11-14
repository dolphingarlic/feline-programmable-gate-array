SOURCES :=                                      \
	hdl/                                        \
	obj/                                        \
	xdc/                                        \
	sim/                                        \
	ip/                                         \

.PHONY: flash
flash:
	openFPGALoader -b arty_s7_50 obj/final.bit

.PHONY: build
build:
	cp build/build.py build.py
	./remote/r.py build.py build.tcl $(SOURCES)

.PHONY: dct
dct:
	cp build/sim_dct.py build.py
	./remote/r.py build.py xsim_run.tcl $(SOURCES)
	gtkwave dump.vcd

.PHONY: clean
clean:
	rm -rf obj/*
	rm -rf vcd/*
	rm -rf vivado.log
