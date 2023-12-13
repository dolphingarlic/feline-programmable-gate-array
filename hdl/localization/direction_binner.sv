`timescale 1ns / 1ps
`default_nettype none

/**
    Computes the mangitude of noise from 16 directions

    Outputs the bin with the highest noise
*/

module direction_binner #(
    parameter DATA_WIDTH = 32,
    parameter QUANTITY = 199
)(
    input wire clk_in,
    input wire rst_in,

    input wire direction_valid_in,
    input wire [DATA_WIDTH - 1:0] direction,
    input wire [(DATA_WIDTH / 2) - 1:0] magnitude,

    output logic [4:0] bin,
    output logic [AGGREGATE_WIDTH:0] magnitude_out,
    output logic bin_valid_out,
    output logic aggregator_ready,

    input wire m_axis_tready
);

    // We need to define the angles for the bins

    localparam [15:0] ANGLE_BINS [0:8] = { // all are 16, 3.13 signed fixed point
        16'h0000, // 0
        16'h0c91, // pi/8
        16'h1922, // pi/4
        16'h25b3, // 3pi/8
        16'h3244, // pi/2
        16'h3ed5, // 5pi/8
        16'h4b66, // 3pi/4
        16'h57f7, // 7pi/8
        16'h6488  // pi
    };

    // First we need to get the angle from the direction vector
    logic cordic_valid;
    logic [DATA_WIDTH - 1:0] angle_phase_data;

    cordic_0 cordic_inst (
        .aclk(clk_in),
        .s_axis_cartesian_tdata(direction),
        .s_axis_cartesian_tvalid(direction_valid_in),
        .s_axis_cartesian_tready(aggregator_ready),
        .m_axis_dout_tdata(angle_phase_data),
        .m_axis_dout_tvalid(cordic_valid)
    );

    // Then we want to store the angle
    logic signed [15:0] angle;
    assign angle = signed'(angle_phase_data[31:16]);

    // If we add QUANTIY DATA_WIDTH-bit numbers the maximum size is:
    localparam AGGREGATE_WIDTH = (DATA_WIDTH / 2) + $clog2(QUANTITY);
    logic signed [AGGREGATE_WIDTH:0] mag_bins [15:0];

    // We count how many samples we've recieved to know when to output
    logic [$clog2(QUANTITY):0] counter;

    // We want to find the max-value in mag_bins

    logic [AGGREGATE_WIDTH:0] max_value;
    logic [3:0] max_index;

    always_comb begin
        max_value = 0;
        for (integer i = 0; i < 16; i = i + 1) begin
            if (mag_bins[i] > max_value) begin
                max_value = mag_bins[i];
                max_index = i;
            end
        end
    end

    // We want to add the magnitude to the correct bin

    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            for (integer i = 0; i < 16; i = i + 1) begin
                mag_bins[i] <= 0;
            end

            counter <= 0;
            bin_valid_out <= 0;
            magnitude_out <= 0;
            bin <= 0;
        end else if (cordic_valid && counter < QUANTITY) begin

            for (integer i = 0; i < 8; i = i + 1) begin
                // Handle positive angles
                if (signed'(angle) >= signed'(ANGLE_BINS[i]) && signed'(angle) < signed'(ANGLE_BINS[i+1])) begin
                    mag_bins[i] <= signed'(mag_bins[i]) + signed'(magnitude);
                end

                // Handle negative angles
                if (signed'(angle) >= signed'(-ANGLE_BINS[8-i]) && signed'(angle) < signed'(-ANGLE_BINS[7-i])) begin
                    mag_bins[i + 8] <= signed'(mag_bins[i + 8]) + signed'(magnitude);
                end
            end

            counter <= counter + 1;
        end else if (counter == QUANTITY && !bin_valid_out) begin
            bin_valid_out <= 1;
            bin <= max_index;
            magnitude_out <= mag_bins[max_index];
        end else if (m_axis_tready && bin_valid_out) begin
            counter <= 0;
            bin_valid_out <= 0;
            bin <= 0;
            magnitude_out <= 0;

            for (integer i = 0; i < 16; i = i + 1) begin
                mag_bins[i] <= 0;
            end
        end
    end

endmodule