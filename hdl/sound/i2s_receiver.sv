`timescale 1ns / 1ps
`default_nettype none

/**
    Main I2S Receiver module
    
    Operates in secondary mode
*/

module i2s_receiver #(
    parameter DATA_WIDTH = 32
) (
    // AXI-Streaming interface
    input wire m_axis_aclk, // Assumes is 98.304MHz
    input wire m_axis_aresetn, // Active low reset
    input wire m_axis_tready, // Indicates secondary ready to receive
    output logic m_axis_tvalid, // Indicates have data to send
    output logic [DATA_WIDTH - 1 : 0] m_axis_tdata [3:0],
    output logic m_axis_tlast,

    // I2S Interface
    input wire sck,
    input wire ws,
    input wire [3:0] sd
);

    logic sckd, sck_rise, sck_fall;

    assign sck_rise = sck && !sckd;
    assign sck_fall = !sck && sckd;

    logic wsd, wsdd, wsp;
    assign wsp = ws ^ wsd;

    logic [$clog2(DATA_WIDTH + 1) - 1:0] counter;

    logic [DATA_WIDTH - 1 : 0] data [3:0];

    always_ff @(posedge m_axis_aclk) begin
        if (sck_fall) begin
            if (wsp) begin

                for (integer i = 0; i < 4; i = i + 1) begin
                    data[i] <= 0;
                    m_axis_tdata[i] <= data[i];
                end

                counter <= 0;
            end else if (counter < DATA_WIDTH) begin

                for (integer i = 0; i < 4; i = i + 1) begin
                    data[i][(DATA_WIDTH - 1) - counter] <= sd[i];
                end
                
                counter <= counter + 1;
            end

            wsdd <= wsd;
            wsd <= ws;
        end

        sckd <= sck;  
    end

    always_ff @(posedge m_axis_aclk) begin
        if (!m_axis_aresetn) begin
            m_axis_tvalid <= 0;
        end else if (sck_fall && wsp) begin
            // m_axis_tvalid <= (^data !== 1'bx); // to get rid of werid simulation issue
            m_axis_tvalid <= 1;
            m_axis_tlast <= wsd;
        end else if (m_axis_tready) begin
            m_axis_tvalid <= 0;
        end
    end

endmodule;

`default_nettype wire