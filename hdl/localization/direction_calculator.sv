`timescale 1ns / 1ps
`default_nettype none

/**
    Computes the direction vector for a given frequency.

    Gets the phase difference between the outer microphones and the center microphone.
    Then scales by the microphones positions and sums all. Finally output is scaled
    by central magnitude.

    We pay particular attention to the bit sizes since they grow really quickly with all the adding
    and multiplying.

    TODO: Improve this code!
*/

module direction_calculator #(
    parameter PERIPHERAL_MICS = 3,
    parameter DATA_WIDTH = 32
) (
    // CENTRAL MICROPHONE
    input logic [DATA_WIDTH - 1: 0] central_mic,
    input logic [(DATA_WIDTH / 2) - 1: 0] central_mic_location [2],
    // PERIPHERAL MICROPHONES
    input logic [DATA_WIDTH - 1: 0] peripheral_mics [PERIPHERAL_MICS-1:0],
    input logic [(DATA_WIDTH / 2) - 1: 0] mic_locations [PERIPHERAL_MICS-1:0][2],
    // OUTPUT
    output logic signed [DATA_WIDTH - 1:0] vector,
    output logic signed [(DATA_WIDTH / 2):0] phase_differences [PERIPHERAL_MICS - 1:0]
);

    always_comb begin
        for (integer i = 0; i < PERIPHERAL_MICS; i = i + 1) begin: loop
            phase_differences[i] = signed'(peripheral_mics[i][DATA_WIDTH - 1:DATA_WIDTH / 2]) - signed'(central_mic[DATA_WIDTH - 1:DATA_WIDTH / 2]);

            // We need to constraint the phase_difference to be between -pi and pi
            
            // 16'h6488 is pi in 2Q13 format.
            if (phase_differences[i] > signed'(16'h6488)) begin
                // We want to subtract 2pi = 16'hC910 in 2Q13
                phase_differences[i] = phase_differences[i] - signed'(17'hC910);
            end else if (phase_differences[i] < signed'(-16'h6488)) begin
                phase_differences[i] = phase_differences[i] + signed'(17'hC910);
            end
        end
    end

    assign vector = 0;
endmodule


// logic [31:0] mic_central, mic_1, mic_2, mic_3;

    // logic signed [18:0] x_sum;
    // logic signed [18:0] y_sum;

    // assign mic_central = data_in[127:96];
    // assign mic_1 = data_in[95:64];
    // assign mic_2 = data_in[63:32];
    // assign mic_3 = data_in[31:0];

    // assign x_sum = -(signed'(mic_2[31:16]) - signed'(mic_central[31:16])) + (signed'(mic_3[31:16]) - signed'(mic_central[31:16]));
    // assign y_sum = (signed'(mic_1[31:16]) - signed'(mic_central[31:16])) - (signed'(mic_2[31:16]) - signed'(mic_central[31:16])) - (signed'(mic_3[31:16]) - signed'(mic_central[31:16]));

    // assign vector = {x_sum >> 3, y_sum >> 3};

