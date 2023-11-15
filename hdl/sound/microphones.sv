`timescale 1ns / 1ps
`default_nettype none

/**
 * @brief Microphone module
 * @details This module reads from the 4 microphones
*/

module microphones(
    input wire clk_in,
    input wire rst_in,
    
    input wire mic_data,
    output wire mic_lr_clk,
    output wire mic_sclk,

    input wire axis_aud_tready,
    output wire axis_aud_tdata,
    output wire axis_aud_tvalid,
);

    // Generate a 2.048Mhz clock signal for the I2S receiver
    logic [20:0] aud_clk_count;
    logic aud_clk;

    always_ff @(posedge clk_100mhz) begin
        if (rst_in) begin
            aud_clk <= 0;
            aud_clk_count <= 0;
        end else if (aud_clk_count == 1_024_000) begin
            aud_clk = ~aud_clk;
            aud_clk_count <= 0;
        end else begin
            aud_clk_count <= aud_clk_count + 1;
        end
    end

    i2s_receiver i2s_receiver_inst(
        // AXI4-Lite interface
        .s_axi_ctrl_aclk(clk_in),
        // AXI-Streaming for data
        .m_axis_aud_aclk(clk_in),
        .m_axis_aud_tdata(axis_aud_tdata),
        .m_axis_aud_tvalid(axis_aud_tvalid),
        .m_axis_aud_tready(axis_aud_tready)
        // I2S interface
        .aud_clk(aud_clk), // I2S clock - Everything else based on this
        .aud_mrst(rst_in),
        .lrclk_out(mic_lr_clk), // Left/Right clock - Output to the microphone
        .sclk_out(mic_sclk), // Serial clock - Output to the microphone
        .sdata_0_in(mic_data), // Serial data - Input from the microphone
    );

endmodule

`default_nettype wire