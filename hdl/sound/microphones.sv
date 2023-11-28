`timescale 1ns / 1ps
`default_nettype none

/**
 * @brief Microphone module
 * @details This module reads from the 4 microphones, applies a low-pass filter, decimates, and adjusts the gain
*/

module microphones(
    input wire clk_in, // Takes the 98.304MHz clock
    input wire rst_in,

    // Microphone signals
    input wire mic_data,
    output logic mic_sck,
    output logic mic_ws,

    output logic signed [15:0] audio_data,
    output logic audio_valid
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
        .m_axis_aresetn(!rst_in),
        .m_axis_tready(i2s_receiver_tready),
        .m_axis_tvalid(i2s_receiver_tvalid),
        .m_axis_tdata(i2s_receiver_tdata),
        .m_axis_tlast(i2s_receiver_tlast),
        // I2S Interface
        .sck(sck),
        .ws(ws),
        .sd(mic_data)
    ); 

    // We only output on the left channel (this efficiently halves the sample rate to 32 kHz)

    logic signed [23:0] signed_i2s_data;

    always_ff @(posedge clk_in) begin
        if (i2s_receiver_tvalid && !i2s_receiver_tlast) begin
            signed_i2s_data <= signed'(i2s_receiver_tdata[31:8]);
        end
    end

    // Then we pass the data to an FIR filter (coefficents generated with matlab fdatool function)

    logic signed [15:0] fir_data;
    logic fir_tvalid;

    fir_compiler_1 fir_inst (
        .aclk(clk_in),
        .s_axis_data_tvalid(i2s_receiver_tvalid),
        .s_axis_data_tready(i2s_receiver_tready),
        .s_axis_data_tdata(signed_i2s_data), // microphones only output 24 bits of data
        .m_axis_data_tvalid(fir_tvalid),
        .m_axis_data_tdata(fir_data)
    );

    assign audio_data = fir_data << 6; // We apply gain to the audio since top bits aren't useful
    assign audio_valid = fir_tvalid;
endmodule

`default_nettype wire