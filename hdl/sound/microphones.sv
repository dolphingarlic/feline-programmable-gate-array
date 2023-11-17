`timescale 1ns / 1ps
`default_nettype none

/**
 * @brief Microphone module
 * @details This module reads from the 4 microphones, applies a low-pass filter, decimates, calculates the fft, and finally outputs that data
*/

module microphones(
    input wire clk_in,
    input wire rst_in

    // Microphone signals
    input wire mic_data,
    output logic mic_sck,
    output logic mic_ws,
);
    
    // I2S needs a main controller to generate the sck and ws signals
    logic sck, ws;

    i2s_controller i2s_controller_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .sck(sck),
        .ws(ws)
    );

    assign mic_sck = sck;
    assign mic_ws = ws;

    // We create an I2S receiver (in secondary mode) to read data from the microphones

    logic i2s_receiver_tready;
    logic i2s_receiver_tvalid;

    logic [31:0] i2s_receiver_tdata;
    logic i2s_receiver_tlast;

    i2s_receiver i2s_receiver_inst (
        .m_axis_aclk(clk_in),
        .m_axis_aresetn(rst_in),
        .m_axis_tready(i2s_receiver_tready),
        .m_axis_tvalid(i2s_receiver_tvalid),
        .m_axis_tdata(i2s_receiver_tdata),
        .m_axis_tlast(i2s_receiver_tlast),
        // I2S Interface
        .sck(sck),
        .ws(ws),
        .sd(mic_data)
    );

    // Then we pass the data to an FIR filter (coefficents generated with matlab fir1 function)

    logic fir_data[31:0];
    logic fir_tvalid;

    fir_compiler_0 fir_inst (
        .aclk(clk_in),
        .s_axis_data_tvalid(i2s_receiver_tvalid),
        .s_axis_data_tready(i2s_receiver_tready),
        .s_axis_data_tdata(i2s_receiver_tdata[31:8]), // microphones only output 24 bits of data
        .m_axis_data_tvalid(fir_tvalid),
        .m_axis_data_tdata(fir_data)
    );

    // Then we need to decimate the data to 6 kHz

    // TODO

    // Then we pass the data through an FFT

    // TODO
endmodule

`default_nettype wire