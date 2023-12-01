`timescale 1ns / 1ps
`default_nettype none

module localizer (
    input wire clk_in,
    input wire rst_in,

    input wire [127:0] fft_data_in,
    input wire fft_valid_in,
);

    //////////////////////////////////////////////
    // Convert values from rectangular to polar //
    //////////////////////////////////////////////

    logic translate_ready;
    logic [31: 0] translate_data [3:0];
    logic translate_valid;

    translate translate_inst (
        .clk_in(clk_in),
        .data_in(fft_data_in),
        .valid_in(fft_valid_in),
        .ready_out(translate_ready)

        .data_out(translate_data),
        .valid_out(translate_valid)
    );



endmodule;


`default_nettype wire