`timescale 1ns / 1ps
`default_nettype none

module localizer (
    input wire clk_in,
    input wire rst_in,

    input wire [127:0] fft_data_in, // FFT data is MSB:X_IM,X_RE:0 – https://docs.xilinx.com/r/en-US/pg109-xfft/TDATA-Format?tocId=sjbj66N~wbday6WKmKSDKg
    input wire fft_valid_in,

    output logic angle_valid_out,
    output logic localizer_ready_out,
    output logic [15:0] angle
);

    //////////////////////////////////////////////
    // Convert values from rectangular to polar //
    //////////////////////////////////////////////

    logic [31:0] translate_data [3:0];
    logic translate_valid;
    logic aggregator_ready;

    translate translate_inst (
        .clk_in(clk_in),
        .data_in(fft_data_in), // MSB:Y_IN,X_IN:0 https://docs.xilinx.com/v/u/en-US/pg105-cordic pg 16
        .valid_in(fft_valid_in),

        .ready_out(localizer_ready_out),
        .data_out(translate_data),
        .valid_out(translate_valid)
    );
    
    //////////////////////////////////////////////
    // Calculate the direction vector           //
    //////////////////////////////////////////////

    logic signed [31:0] direction_vector;

    direction_calculator direction_calculator_inst (
        .central_mic(translate_data[0]),
        .peripheral_mics(translate_data[3:1]),
        .vector(direction_vector)
    );
   
    ///////////////////////////////////////////////
    // Sum direction vectors to get angle        //
    ///////////////////////////////////////////////

    direction_aggregator direction_aggregator_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .direction_valid_in(translate_valid),
        .direction(direction_vector),

        .angle(angle),
        .angle_valid_out(angle_valid_out),
        .aggregator_ready(aggregator_ready)
    );

endmodule;


`default_nettype wire