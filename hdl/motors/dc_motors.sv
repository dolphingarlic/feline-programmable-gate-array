`timescale 1ns / 1ps
`default_nettype none

/**
  DC Motor Control Module - Given two 8 bit speeds, generate two PWM signals to control the motors

  Note we run PWM at 20 kHz so you can't hear the motors hopefully
**/

module dc_motors (
            input wire clk_in, // at 98.304 MHz
            input wire rst_in,

            input wire signed [7:0] speed_left,
            input wire signed [7:0] speed_right,

            output logic in1,
            output logic in2,
            output logic ena,

            output logic in3,
            output logic in4,
            output logic enb
);

    logic [13:0] counter;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            counter <= 0;
            in1 <= 0;
            in2 <= 0;
            ena <= 0;
            in3 <= 0;
            in4 <= 0;
            enb <= 0;
        end else begin
            // Clockwise
            in1 <= 0;
            in2 <= 1;

            in3 <= 0;
            in4 <= 1;

            if (counter == 4915) begin
                ena <= 1;
                enb <= 1;
                counter <= 0;
            end else begin
                counter <= counter + 1;

                if (counter == 4500) begin
                    ena <= 0;
                    enb <= 0;
                end
            end 
        end
    end

endmodule
`default_nettype wire

