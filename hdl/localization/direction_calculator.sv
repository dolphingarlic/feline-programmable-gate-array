`timescale 1ns / 1ps
`default_nettype none

/**
    Computes the direction vector for a given frequency.

    Gets the phase difference between the outer microphones and the center microphone.
    Then scales by the microphones positions and sums all. Finally output is scaled
    by central magnitude.

    We pay particular attention to the bit sizes since they grow really quickly with all the adding
    and multiplying.

    Microphone data is phase, mag each 16 bits in 3.13 fixed point form
*/

module direction_calculator(
    // CENTRAL MICROPHONE
    input logic [31:0] central_mic,
    // PERIPHERAL MICROPHONES
    input logic [31:0] peripheral_mics [3],
    // OUTPUT (x,y each 16 bits 5.11 fixed point)
    output logic signed [31:0] vector
);
    logic signed [16:0] phase_differences [2:0]; // Each is 17 bits 4.13 fixed point
    // NOTE: Since we constraint phase_differences to be -pi to pi we know it actually only takes up 16 bits 
    logic signed [15:0] scaled_locations [2:0][1:0]; // Each loc has x,y. Both are 3.13
    logic signed [17:0] summed_locations [2]; // x, y both are 18 bits 5.13 fixed point
   
    always_comb begin

        for (integer i = 0; i < 3; i = i + 1) begin: loop
            phase_differences[i] = signed'(peripheral_mics[i][31:16]) - signed'(central_mic[31:16]);

            // We need to constraint the phase_difference to be between -pi and pi
            if (phase_differences[i] > signed'(16'h6488)) begin // 16'h6488 is pi in 2Q13 format.
                // We want to subtract 2pi = 16'hC910 in 2Q13
                phase_differences[i] = phase_differences[i] - signed'(17'hC910);
            end else if (phase_differences[i] < signed'(-16'h6488)) begin
                phase_differences[i] = phase_differences[i] + signed'(17'hC910);
            end
        end

        /* Then we can scale the location vectors:
            Central: (0, 0)
            1: (0, 1)
            2: (-1, -1)
            3: (1, -1)
        **/

        // MIC-1
        scaled_locations[0][0] = 0;
        scaled_locations[0][1] = phase_differences[0];

        // MIC-2
        scaled_locations[1][0] = -phase_differences[1];
        scaled_locations[1][1] = -phase_differences[1];

        // MIC-3
        scaled_locations[2][0] = phase_differences[2];
        scaled_locations[2][1] = -phase_differences[2];

        // Finally we can sum all the vectors
        summed_locations[0] = 0;
        summed_locations[1] = 0;

        for (integer i = 0; i < 3; i = i + 1) begin
            summed_locations[0] = summed_locations[0] + scaled_locations[i][0];
            summed_locations[1] = summed_locations[1] + scaled_locations[i][1];
        end
    end

    assign vector = {summed_locations[0] >> 2, summed_locations[1] >> 2};
endmodule