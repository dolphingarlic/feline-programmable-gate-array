`timescale 1ns / 1ps
`default_nettype none

/**
    Computes an average direction vector from 256 individual direction vectors
*/

module direction_aggregator #(
    parameter DATA_WIDTH = 32,
    parameter QUANTITY = 199
)(
    input wire clk_in,
    input wire rst_in,

    input wire direction_valid_in,
    input wire [DATA_WIDTH - 1:0] direction,
    input wire [(DATA_WIDTH / 2) - 1:0] magnitude,

    // output logic [(DATA_WIDTH / 2) - 1:0] angle,
    output logic signed [23:0] mag_bins [3:0],
    output logic angle_valid_out,
    output logic aggregator_ready,

    input wire m_axis_tready,
    output logic [$clog2(QUANTITY):0] counter
);

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
    
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            for (integer i = 0; i < 4; i = i + 1) begin
                mag_bins[i] <= 0;
            end

            counter <= 0;
            angle_valid_out <= 0;
        end else if (cordic_valid && counter < QUANTITY) begin
        
            // if (signed'(angle) >= 0 && signed'(angle) < signed'(16'h3244)) begin
            //     // Between 0 and pi
            //     mag_bins[0] = signed'(mag_bins[0]) + signed'(magnitude);
            // end else if (signed'(angle) >= signed'(16'h3244)) begin
            //     // pi/2 or greater
            //     mag_bins[1] = signed'(mag_bins[1]) + signed'(magnitude);
            // end else if (signed'(angle) <= signed'(-16'h3244)) begin
            //     // -pi/2 or less
            //     mag_bins[2] = signed'(mag_bins[1]) + signed'(magnitude);
            // end else begin
            //     // Between 0 and -pi
            //     mag_bins[3] = signed'(mag_bins[1]) + signed'(magnitude);
            // end

            // if (signed'(angle) >= 0) begin
            //     mag_bins[0] <= signed'(mag_bins[0]) + signed'(magnitude);
            // end else begin
            //     mag_bins[1] <= signed'(mag_bins[1]) + signed'(magnitude);
            // end

            if (signed'(angle) >= signed'(-16'h3244) && signed'(angle) < signed'(16'h3244)) begin
                // Between pi/2 and -pi/2
                mag_bins[0] <= signed'(mag_bins[0]) + signed'(magnitude);
            end else begin
                // pi/2 or greater
                mag_bins[1] <= signed'(mag_bins[1]) + signed'(magnitude);
            end

            counter <= counter + 1;
        end else if (counter == QUANTITY && !angle_valid_out) begin
            angle_valid_out <= 1;
        end else if (m_axis_tready && angle_valid_out) begin
            counter <= 0;
            angle_valid_out <= 0;
            for (integer i = 0; i < 4; i = i + 1) begin
                mag_bins[i] <= 0;
            end
        end
    end

endmodule