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

.PHONY: gen_triangular_filters
gen_triangular_filters:
	python3 sw/gen_triangular_filters.py
	iverilog -g2012 -o sim/gen_triangular_filters.out sim/gen_triangular_filters_tb.sv hdl/biometrics/feature_extractor/gen_triangular_filters.sv
	vvp sim/gen_triangular_filters.out
	gtkwave vcd/gen_triangular_filters.vcd

.PHONY: mel_filterbank
mel_filterbank:
	iverilog -g2012 -o sim/mel_filterbank.out sim/mel_filterbank_tb.sv hdl/biometrics/feature_extractor/mel_filterbank.sv hdl/biometrics/feature_extractor/gen_triangular_filters.sv hdl/common/pipeline.sv
	vvp sim/mel_filterbank.out
	gtkwave vcd/mel_filterbank.vcd

.PHONY: uart_tick_generator
uart_tick_generator:
	iverilog -g2012 -o sim/uart_tick_generator.out sim/uart_tick_generator_tb.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_tick_generator.out
	gtkwave vcd/uart_tick_generator.vcd

.PHONY: uart_rx
uart_rx:
	iverilog -g2012 -o sim/uart_rx.out sim/uart_rx_tb.sv hdl/common/uart_rx.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_rx.out
	gtkwave vcd/uart_rx.vcd

.PHONY: uart_tx
uart_tx:
	iverilog -g2012 -o sim/uart_tx.out sim/uart_tx_tb.sv hdl/common/uart_tx.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_tx.out
	gtkwave vcd/uart_tx.vcd

.PHONY: uart_end_to_end
uart_end_to_end:
	iverilog -g2012 -o sim/uart_end_to_end.out sim/uart_end_to_end_tb.sv hdl/common/uart_tx.sv hdl/common/uart_rx.sv hdl/common/uart_tick_generator.sv
	vvp sim/uart_end_to_end.out
	gtkwave vcd/uart_end_to_end.vcd

.PHONY: i2s_receiver
i2s_receiver:
	iverilog -g2012 -o sim/i2s_receiver.out sim/i2s_receiver_tb.sv hdl/sound/i2s_controller.sv hdl/sound/i2s_receiver.sv
	vvp sim/i2s_receiver.out
	gtkwave i2s_receiver.vcd

.PHONY: microphones_no_ip
microphones_no_ip:
	iverilog -g2012 -o sim/microphones_no_ip.out sim/microphones_tb.sv hdl/sound/i2s_controller.sv hdl/sound/i2s_receiver.sv hdl/sound/microphones.sv
	vvp sim/microphones_no_ip.out
	gtkwave microphones_no_ip.vcd

.PHONY: direction_calculator
direction_calculator:
	iverilog -g2012 -o sim/direction_calculator.out sim/direction_calculator_tb.sv hdl/localization/direction_calculator.sv
	vvp sim/direction_calculator.out

.PHONY: clean
clean:
	rm -rf obj/*
	rm -rf vcd/*
	rm -rf vivado.log
