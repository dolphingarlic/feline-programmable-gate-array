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

.PHONY: uart_tick_generator
uart_tick_generator:
	iverilog -g2012 -o sim/uart_tick_generator.out sim/uart_tick_generator_tb.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_tick_generator.out
	gtkwave uart_tick_generator.vcd

.PHONY: uart_rx
uart_rx:
	iverilog -g2012 -o sim/uart_rx.out sim/uart_rx_tb.sv hdl/common/uart_rx.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_rx.out
	gtkwave uart_rx.vcd

.PHONY: uart_tx
uart_tx:
	iverilog -g2012 -o sim/uart_tx.out sim/uart_tx_tb.sv hdl/common/uart_tx.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_tx.out
	gtkwave uart_tx.vcd

.PHONY: clean
clean:
	rm -rf obj/*
	rm -rf vcd/*
	rm -rf vivado.log
