from math import exp, log, log2, ceil

N_FFT = 512
NUM_FILTERS = 26
FREQ_LOWERBOUND_HZ = 20
FREQ_UPPERBOUND_HZ = 3000
SAMPLE_RATE_HZ = 6000
INV_PRECISION = 10

FREQ_LOWERBOUND_MEL = log(700 + FREQ_LOWERBOUND_HZ)
FREQ_UPPERBOUND_MEL = log(700 + FREQ_UPPERBOUND_HZ)
MEL_SPACING = (FREQ_UPPERBOUND_MEL - FREQ_LOWERBOUND_MEL) / (NUM_FILTERS + 1)

VERILOG_PREAMBLE = f"""///////////////////////////////
//    AUTO-GENERATED FILE    //
// ------------------------- //
// N_FFT = {N_FFT}               //
// NUM_FILTERS = {NUM_FILTERS}          //
// FREQ_LOWERBOUND_HZ = {FREQ_LOWERBOUND_HZ}   //
// FREQ_UPPERBOUND_HZ = {FREQ_UPPERBOUND_HZ} //
// SAMPLE_RATE_HZ = {SAMPLE_RATE_HZ}     //
// INV_PRECISION = {INV_PRECISION}        //
///////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

"""

MODULE_BOILERPLATE_START = f"""  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [{int(ceil(log2(N_FFT))) - 1}:0] k_in,
  output logic [31:0] filtered_out
);

  logic [{INV_PRECISION}:0] scale_factor;
  logic [{31-INV_PRECISION}:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:{INV_PRECISION}];
      case (k_in)
"""

MODULE_BOILERPLATE_END = f"""        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


"""

TESTBENCH_BOILERPLATE_START = f"""`timescale 1ns / 1ps
`default_nettype none

module gen_triangular_filters_tb;

  // Input logics
  logic clk_in, rst_in;
  logic [31:0] power_in;
  logic [{int(ceil(log2(N_FFT))) - 1}:0] k_in;

"""

TESTBENCH_BOILERPLATE_END = f"""
  always begin
      #5; // 100MHz clock
      clk_in = !clk_in;
  end

  initial begin
    $dumpfile("gen_triangular_filters.vcd");
    $dumpvars(0, gen_triangular_filters_tb);
    $display("Starting sim");

    // Initialize variables
    clk_in = 0;
    rst_in = 0;
    power_in = 0;
    k_in = 0;

    // Wait a lil bit and reset
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test case 1: flat signal
    power_in = 32'hDEADBEEF;
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    // Test case 2: sine wave
    for (int i = 0; i < 512; i = i + 1) begin
      k_in = i;
      power_in = 32'hDEADBEEF * $sin(i / 5.0) * $sin(i / 5.0);
      #10;
    end
    power_in = 0;
    k_in = 0;
    #100;

    $display("Finishing Sim");
    $finish;
  end

endmodule

`default_nettype wire
"""

# Generate the modules
with open('hdl/biometrics/feature_extractor/gen_triangular_filters.sv', 'w') as f:
    f.write(VERILOG_PREAMBLE)

    for i in range(NUM_FILTERS):
        peak_mel = FREQ_LOWERBOUND_MEL + (i + 1) * MEL_SPACING
        start_hz = exp(peak_mel - MEL_SPACING) - 700
        peak_hz = exp(peak_mel) - 700
        stop_hz = exp(peak_mel + MEL_SPACING) - 700

        start_k = round((N_FFT + 1) * start_hz / SAMPLE_RATE_HZ)
        peak_k = round((N_FFT + 1) * peak_hz / SAMPLE_RATE_HZ)
        stop_k = round((N_FFT + 1) * stop_hz / SAMPLE_RATE_HZ)

        # Initialize the module
        f.write(f'module triangular_filter_{i} (\n')
        f.write(MODULE_BOILERPLATE_START)
        
        # Calculate the scale factor
        f.write('        // Rising edge\n')
        inv_lower_bandwidth = 2**INV_PRECISION / (peak_k - start_k)
        for j in range(start_k, peak_k):
            scale_factor = (j - start_k) * inv_lower_bandwidth
            f.write(f'        {j}: scale_factor <= {round(scale_factor)};\n')

        f.write('        // Falling edge\n')
        inv_upper_bandwidth = 2**INV_PRECISION / (stop_k - peak_k)
        for j in range(peak_k, stop_k):
            scale_factor = (stop_k - j) * inv_upper_bandwidth
            f.write(f'        {j}: scale_factor <= {round(scale_factor)};\n')

        # End the module
        f.write(MODULE_BOILERPLATE_END)

    f.write('`default_nettype wire\n')


# Generate a testbench

with open('sim/gen_triangular_filters_tb.sv', 'w') as f:
    f.write(TESTBENCH_BOILERPLATE_START)
    for i in range(NUM_FILTERS):
        f.write(f'  logic [31:0] filtered_out_{i};\n')
        f.write(f'  triangular_filter_{i} uut_{i} (.clk_in(clk_in), .rst_in(rst_in),\n')
        f.write(f'    .power_in(power_in), .k_in(k_in), .filtered_out(filtered_out_{i}));\n\n')
    f.write(TESTBENCH_BOILERPLATE_END)


# Generate the instances
print('INSTANTIATION TEMPLATE')
print('----------------------')
for i in range(NUM_FILTERS):
    print(f'  triangular_filter_{i} triangular_filter_inst_{i} (.clk_in(clk_in), .rst_in(rst_in),')
    print(f'    .power_in(power_data_in), .k_in(k_curr), .filtered_out(filter_buffer[{i}]));')
