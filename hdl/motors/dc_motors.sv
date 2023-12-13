`timescale 1ns / 1ps
`default_nettype none

/**
  DC Motor Control Module - Given two 8 bit speeds, generate two PWM signals to control the motors

  Note we run PWM at 20 kHz so the microphones aren't interfered with by noise from the motors 
**/

module dc_motors #(
    parameter PWM_FREQ = 4915 // 20 kHz so 98.304 MHz / 20 = 4915
)(
            input wire clk_in, // at 98.304 MHz
            input wire rst_in,

            input wire [$clog2(PWM_FREQ):0] speed_left,
            input wire [$clog2(PWM_FREQ):0] speed_right,

            output logic in1,
            output logic in2,
            output logic ena,

            output logic in3,
            output logic in4,
            output logic enb
);
    
    logic [$clog2(PWM_FREQ):0] counter;

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            counter <= 0;

            // Right motor should move clockwise
            in1 <= 0;
            in2 <= 1;

            // Left motor should move clockwise
            in3 <= 0;
            in4 <= 1;

            // We start with it enabled
            ena <= 1;
            enb <= 1;
        end else begin
            if (counter == PWM_FREQ - 1) begin
                ena <= 1;
                enb <= 1;
                counter <= 0;
            end else begin
                counter <= counter + 1;

                if (counter == speed_right) begin
                    ena <= 0;
                end

                if (counter == speed_left) begin
                    enb <= 0;
                end
            end 
        end
    end

endmodule
`default_nettype wire

