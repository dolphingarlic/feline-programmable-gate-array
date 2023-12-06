`timescale 1ns / 1ps
`default_nettype none

/**
    Converts data from FFT from rectangular to polar coordinates.

    @param CHANNELS Number of channels to convert

    See: https://docs.xilinx.com/api/khub/documents/NHMqdvRJIfgF8hdbQmLFuA/content?Ft-Calling-App=ft%2Fturnkey-portal&Ft-Calling-App-Version=4.2.23#G6.296930 for detials

    Note (from pg 22):
    The individual input vector elements, (X_IN, Y_IN), and the output magnitude, X_OUT, are
    expressed as fixed-point twos complement numbers with an integer width of 2 bits (1QN
    format). The output phase angle, PHASE_OUT radians, is expressed as a fixed-point twos
    complement number with an integer width of 3 bits (2QN format).

    Note that X_OUT is scaled by a constant factor but since we don't care about distance we don't care about this
**/

module translate #(
    parameter CHANNELS = 4,
    parameter DATA_WIDTH = 32
)(
    input wire clk_in,
    input wire rst_in,

    input wire [(CHANNELS * DATA_WIDTH) - 1:0] data_in,
    input wire valid_in,
    output wire ready_out,

    output logic [DATA_WIDTH - 1: 0] data_out [CHANNELS - 1:0],
    output logic valid_out
);

    logic [CHANNELS - 1:0] cordic_valids; // Store channels worth of valids
    logic [CHANNELS - 1:0] cordic_readys;  // Store channels worth of readys

    logic [DATA_WIDTH - 1: 0] data [CHANNELS - 1:0];

    genvar i;

    generate
        for (i = 0; i < CHANNELS; i = i + 1) begin: loop
            cordic_0 cordic_inst (
                .aclk(clk_in),
                .s_axis_cartesian_tdata(data_in[(DATA_WIDTH * i) +: DATA_WIDTH]),
                .s_axis_cartesian_tvalid(valid_in),
                .s_axis_cartesian_tready(cordic_readys[i]),
                .m_axis_dout_tdata(data[i]),
                .m_axis_dout_tvalid(cordic_valids[i])
            );
        end
    endgenerate   

    assign ready_out = &cordic_readys;

    // We want to store results in register
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            valid_out <= 0;
            for (integer j = 0; j < CHANNELS; j = j + 1) begin
                data_out[j] <= 0;
            end
        end else if (&cordic_valids) begin
            valid_out <= 1;
            for (integer j = 0; j < CHANNELS; j = j + 1) begin
                data_out[j] <= data[j];
            end
        end else if (valid_out) begin
            valid_out <= 0;
        end
    end

endmodule

`default_nettype wire