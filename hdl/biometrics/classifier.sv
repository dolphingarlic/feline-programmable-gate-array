`timescale 1ns / 1ps
`default_nettype none

/*
 * Module `classifier`
 *
 * Implements a linear SVM classifier that receives model parameters over UART.
 */
module classifier #(
  parameter NUM_FEATURES_IN = 16
) (
  input wire clk_in,
  input wire rst_in,

  input wire signed [15:0] feature_data_in,
  input wire feature_valid_in,
  input wire feature_last_in,
  
  input wire [7:0] ble_data_in,
  input wire ble_valid_in,

  input wire predict_enable_in,
  output logic detected_out
);

  // We only allow up to 255 support vectors 
  logic [7:0] num_supports, support_write_idx;

  // Other model parameters
  logic signed [31:0] offset;
  logic [1:0] offset_curr_byte;

  // Control signals for writing to BRAM
  logic coef_curr_byte, support_write_valid;
  logic signed [15:0] support_write_data;
  logic [$clog2(NUM_FEATURES_IN)-1:0] support_coef_idx;

  // Control signals for reading from BRAM
  logic [7:0] support_read_idx;
  logic support_read_valid, products_valid_buffer;
  logic signed [15:0] support_read_data [NUM_FEATURES_IN-1:1];

  pipeline #(
    .WIDTH(1),
    .DEPTH(5)
  ) support_read_pipeline (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .val_in(support_read_valid),
    .val_out(products_valid_buffer)
  );

  generate
    genvar i;
    for (i = 1; i < NUM_FEATURES_IN; i = i + 1) begin
      xilinx_true_dual_port_read_first_2_clock_ram #(
        .RAM_WIDTH(16),
        .RAM_DEPTH(256)
      ) support_vector_buffer (
        // WRITE SIDE
        .addra(support_write_idx),
        .clka(clk_in),
        .wea(support_write_valid && support_coef_idx == i),
        .dina(support_write_data),
        .ena(1'b1),
        .regcea(1'b1),
        .rsta(rst_in),
        .douta(),

        // READ SIDE
        .addrb(support_read_idx),
        .dinb(16'b0),
        .clkb(clk_in),
        .web(1'b0),
        .enb(support_read_valid),
        .rstb(rst_in),
        .regceb(1'b1),
        .doutb(support_read_data[i])
      );
    end
  endgenerate

  //////////////////////
  // HANDLE BLE INPUT //
  //////////////////////
  typedef enum { BLE_IDLE=0, READ_COEF=1, WRITE=2, READ_OFFSET=3 } ble_state;
  ble_state write_state;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      num_supports <= 0;
      support_write_valid <= 0;
      write_state <= BLE_IDLE;
    end else begin
      if (write_state == BLE_IDLE && ble_valid_in) begin
        // First, we read in the number of support vectors
        num_supports <= ble_data_in;
        support_write_idx <= 0;
        support_coef_idx <= 1; // We only care about features 1 through 15
        support_write_valid <= 0;
        coef_curr_byte <= 0;
        write_state <= READ_COEF;
      end else if (write_state == READ_COEF && ble_valid_in) begin
        support_write_data <= {support_write_data[7:0], ble_data_in};
        coef_curr_byte <= ~coef_curr_byte;
        // If we've read 2 bytes of data from UART -> write to BRAM
        if (coef_curr_byte) begin
          support_write_valid <= 1;
          write_state <= WRITE;
        end
      end else if (write_state == WRITE) begin
        support_write_valid <= 0;
        if (support_coef_idx == NUM_FEATURES_IN - 1) begin
          // We are done processing the current support vector
          if (support_write_idx == num_supports - 1) begin
            // ... and also all the support vectors, so read the offset now
            offset_curr_byte <= 0;
            write_state <= READ_OFFSET;
          end else begin
            // Else move on to the next vector
            support_coef_idx <= 1;
            support_write_idx <= support_write_idx + 1;
            write_state <= READ_COEF;
          end
        end else begin
          // Move on to the next coefficient
          support_coef_idx <= support_coef_idx + 1;
          write_state <= READ_COEF;
        end
      end else if (write_state == READ_OFFSET && ble_valid_in) begin
        offset <= {offset[23:0], ble_data_in};
        if (offset_curr_byte == 3) write_state <= BLE_IDLE;
        else offset_curr_byte <= offset_curr_byte + 1;
      end
    end
  end

  //////////////////////////
  // COMPUTE DOT PRODUCTS //
  //////////////////////////
  typedef enum { DOT_IDLE=0, READ=1, COMPUTE=2, OUTPUT=3 } dot_prod_state;
  dot_prod_state read_state;

  logic [$clog2(NUM_FEATURES_IN)-1:0] feature_idx;
  logic signed [15:0] feature_buffer [NUM_FEATURES_IN-1:0];
  logic signed [31:0] product_buffer [NUM_FEATURES_IN-1:0];
  logic signed [31:0] dot_product_mid [3:0];
  logic signed [31:0] dot_product_curr, dot_product_sum;

  generate
    genvar j;
    for (j = 1; j < NUM_FEATURES_IN; j = j + 1) begin
      always_ff @(posedge clk_in) begin
        // Pipeline stage 1
        product_buffer[j] <= feature_buffer[j] * support_read_data[j];
      end
    end
    assign product_buffer[0] = 0;

    always_ff @(posedge clk_in) begin
      // Pipeline stage 2
      dot_product_mid[0] <= product_buffer[0] + product_buffer[1] +
                            product_buffer[2] + product_buffer[3];
      dot_product_mid[1] <= product_buffer[4] + product_buffer[5] +
                            product_buffer[6] + product_buffer[7];
      dot_product_mid[2] <= product_buffer[8] + product_buffer[9] +
                            product_buffer[10] + product_buffer[11];
      dot_product_mid[3] <= product_buffer[12] + product_buffer[13] +
                            product_buffer[14] + product_buffer[15];
      // Pipeline stage 3
      dot_product_curr <= dot_product_mid[0] + dot_product_mid[1] +
                          dot_product_mid[2] + dot_product_mid[3];
    end
  endgenerate

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      read_state <= DOT_IDLE;
      support_read_valid <= 0;
    end else begin
      if (read_state == DOT_IDLE) begin
        support_read_valid <= 0;
        if (feature_valid_in && predict_enable_in) begin
          // Start reading in the feature vector
          feature_buffer[0] <= feature_data_in;
          feature_idx <= 1;
          read_state <= READ;
        end
      end else if (read_state == READ && feature_valid_in) begin
        feature_buffer[feature_idx] <= feature_data_in;
        if (feature_last_in) begin
          // Finished reading in the feature vector; start computing the dot product
          support_read_idx <= 0;
          support_read_valid <= 1;
          dot_product_sum <= 0;
          read_state <= COMPUTE;
        end else feature_idx <= feature_idx + 1;
      end else if (read_state == COMPUTE) begin
        if (products_valid_buffer) begin
          dot_product_sum <= dot_product_sum + dot_product_curr;
        end else if (support_read_idx == num_supports - 1) begin
          read_state <= OUTPUT;
        end
        // Stop reading after reading all support vectors
        if (support_read_idx == num_supports - 1) support_read_valid <= 0;
        else support_read_idx <= support_read_idx + 1;
      end else if (read_state == OUTPUT) begin
        detected_out <= (dot_product_sum > offset); // TODO: cutoffs based on magnitude too
        read_state <= DOT_IDLE;
      end
    end
  end

endmodule

`default_nettype wire
