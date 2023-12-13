`timescale 1ns / 1ps
`default_nettype none

/**
    Motor Control Module - Given the bin and the magnitude this module moves the cat towards the bin-
**/

module motor_control #(
    parameter MAG_THRESHOLD = 5000
) (
            input wire clk_in, // at 98.304 MHz
            input wire rst_in,

            input wire [3:0] bin,
            input wire [24:0] mag,
            input wire recognised,

            output logic [2:0] led,

            output logic in1,
            output logic in2,
            output logic ena,
            
            output logic in3,
            output logic in4,
            output logic enb
);

    logic [14:0] speed_left;
    logic [14:0] speed_right;

    dc_motors dc_motors_inst (
        .clk_in(clk_in),
        .rst_in(rst_in),

        .speed_left(speed_left),
        .speed_right(speed_right),

        .in1(in1),
        .in2(in2),
        .ena(ena),

        .in3(in3),
        .in4(in4),
        .enb(enb)
    );

    always_ff @(posedge clk_in) begin
        if (recognised) begin
            case (bin)
                5,6,7,8,9,10,11: begin
                    speed_left <= 15'd0;
                    speed_right <= 15'd2_949;
                    led <= 3'b001;
                end
                3,2,1,0,15,14,13,12: begin
                    speed_left <= 15'd2_949;
                    speed_right <= 15'd0;
                    led <= 3'b010;
                end
            endcase
        end else begin
            speed_left <= 0;
            speed_right <= 0;
            led <= 3'b100;
        end
    end

endmodule
`default_nettype wire

