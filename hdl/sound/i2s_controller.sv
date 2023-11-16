`timescale 1ns / 1ps
`default_nettype none

/**
Generates the sck and ws signals for I2S
*/

module i2s_controller #(
    OVER_SAMPLING_RATE = 64
) (
    input wire clk_in,
    input wire rst_in,
    output logic sck,
    output logic ws
);

    // Generate a 2.048Mhz clock signal for the I2S receiver
    logic [4:0] aud_clk_count;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            sck <= 0;
            aud_clk_count <= 0;
        end else if (aud_clk_count == 24) begin
            sck <= ~sck;
            aud_clk_count <= 0;
        end else begin
            aud_clk_count <= aud_clk_count + 1;
        end
    end

    // WS signal is based off the negative edge of the sck signal

    logic [$clog2(OVER_SAMPLING_RATE / 2) + 1 : 0] ws_counter;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            ws_counter <= 0;
            ws <= 0;
        end else begin
            if (aud_clk_count == 24 && sck) begin
                if (ws_counter == OVER_SAMPLING_RATE / 2 - 1) begin
                    ws <= ~ws;
                    ws_counter <= 0;
                end else begin
                    ws_counter <= ws_counter + 1;
                end
            end
        end
    end

endmodule

