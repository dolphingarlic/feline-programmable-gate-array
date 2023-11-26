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
    input wire m_axis_aclk, // Assumes is 100 mHz
    input wire m_axis_aresetn, // Active low reset
    input wire m_axis_tready, // Indicates secondary ready to receive
    output logic m_axis_tvalid, // Indicates have data to send
    output logic [DATA_WIDTH - 1 : 0] m_axis_tdata,
    output logic m_axis_tlast,

    // I2S Interface
    input wire sck,
    input wire ws,
    input wire sd
);

    logic sckd, sckdd, sck_rise, sck_fall;

    assign sck_rise = sckd && sckdd;
    assign sck_fall = !sckd && sckdd;

    logic wsd, wsdd, wsp;
    assign wsp = wsd ^ wsdd;

    logic [$clog2(DATA_WIDTH + 1) - 1:0] counter;

    logic [0:DATA_WIDTH - 1] data;

    always_ff @(posedge m_axis_aclk) begin
        if (sck_rise) begin
            if (wsp) begin
                data <= 0;
                m_axis_tdata <= data;
            end
            
            if (counter < DATA_WIDTH) begin
                data[counter] <= sd;
            end

            wsdd <= wsd;
            wsd <= ws;
        end else if (sck_fall) begin
            if (wsp) begin
                counter <= 0;
            end else if (counter < DATA_WIDTH) begin
                counter <= counter + 1;
            end
        end

        sckd <= sck;
        sckdd <= sckd;   
    end

    always_ff @(posedge m_axis_aclk) begin
        if (!m_axis_aresetn) begin
            m_axis_tvalid <= 0;
        end else if (sck_rise && wsp) begin
            m_axis_tvalid <= (^data !== 1'bx);
            m_axis_tlast <= !wsd;
        end else if (m_axis_tready) begin
            m_axis_tvalid <= 0;
        end
    end

endmodule;

`default_nettype wire