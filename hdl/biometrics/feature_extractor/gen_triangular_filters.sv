///////////////////////////////
//    AUTO-GENERATED FILE    //
// ------------------------- //
// N_FFT = 512               //
// NUM_FILTERS = 32          //
// FREQ_LOWERBOUND_HZ = 20   //
// FREQ_UPPERBOUND_HZ = 3000 //
// SAMPLE_RATE_HZ = 6000     //
// INV_PRECISION = 10        //
///////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module triangular_filter_0 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        2: scale_factor <= 0;
        3: scale_factor <= 341;
        4: scale_factor <= 683;
        // Falling edge
        5: scale_factor <= 1024;
        6: scale_factor <= 683;
        7: scale_factor <= 341;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_1 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        5: scale_factor <= 0;
        6: scale_factor <= 341;
        7: scale_factor <= 683;
        // Falling edge
        8: scale_factor <= 1024;
        9: scale_factor <= 768;
        10: scale_factor <= 512;
        11: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_2 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        8: scale_factor <= 0;
        9: scale_factor <= 256;
        10: scale_factor <= 512;
        11: scale_factor <= 768;
        // Falling edge
        12: scale_factor <= 1024;
        13: scale_factor <= 683;
        14: scale_factor <= 341;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_3 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        12: scale_factor <= 0;
        13: scale_factor <= 341;
        14: scale_factor <= 683;
        // Falling edge
        15: scale_factor <= 1024;
        16: scale_factor <= 768;
        17: scale_factor <= 512;
        18: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_4 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        15: scale_factor <= 0;
        16: scale_factor <= 256;
        17: scale_factor <= 512;
        18: scale_factor <= 768;
        // Falling edge
        19: scale_factor <= 1024;
        20: scale_factor <= 768;
        21: scale_factor <= 512;
        22: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_5 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        19: scale_factor <= 0;
        20: scale_factor <= 256;
        21: scale_factor <= 512;
        22: scale_factor <= 768;
        // Falling edge
        23: scale_factor <= 1024;
        24: scale_factor <= 768;
        25: scale_factor <= 512;
        26: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_6 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        23: scale_factor <= 0;
        24: scale_factor <= 256;
        25: scale_factor <= 512;
        26: scale_factor <= 768;
        // Falling edge
        27: scale_factor <= 1024;
        28: scale_factor <= 819;
        29: scale_factor <= 614;
        30: scale_factor <= 410;
        31: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_7 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        27: scale_factor <= 0;
        28: scale_factor <= 205;
        29: scale_factor <= 410;
        30: scale_factor <= 614;
        31: scale_factor <= 819;
        // Falling edge
        32: scale_factor <= 1024;
        33: scale_factor <= 768;
        34: scale_factor <= 512;
        35: scale_factor <= 256;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_8 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        32: scale_factor <= 0;
        33: scale_factor <= 256;
        34: scale_factor <= 512;
        35: scale_factor <= 768;
        // Falling edge
        36: scale_factor <= 1024;
        37: scale_factor <= 819;
        38: scale_factor <= 614;
        39: scale_factor <= 410;
        40: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_9 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        36: scale_factor <= 0;
        37: scale_factor <= 205;
        38: scale_factor <= 410;
        39: scale_factor <= 614;
        40: scale_factor <= 819;
        // Falling edge
        41: scale_factor <= 1024;
        42: scale_factor <= 819;
        43: scale_factor <= 614;
        44: scale_factor <= 410;
        45: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_10 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        41: scale_factor <= 0;
        42: scale_factor <= 205;
        43: scale_factor <= 410;
        44: scale_factor <= 614;
        45: scale_factor <= 819;
        // Falling edge
        46: scale_factor <= 1024;
        47: scale_factor <= 853;
        48: scale_factor <= 683;
        49: scale_factor <= 512;
        50: scale_factor <= 341;
        51: scale_factor <= 171;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_11 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        46: scale_factor <= 0;
        47: scale_factor <= 171;
        48: scale_factor <= 341;
        49: scale_factor <= 512;
        50: scale_factor <= 683;
        51: scale_factor <= 853;
        // Falling edge
        52: scale_factor <= 1024;
        53: scale_factor <= 819;
        54: scale_factor <= 614;
        55: scale_factor <= 410;
        56: scale_factor <= 205;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_12 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        52: scale_factor <= 0;
        53: scale_factor <= 205;
        54: scale_factor <= 410;
        55: scale_factor <= 614;
        56: scale_factor <= 819;
        // Falling edge
        57: scale_factor <= 1024;
        58: scale_factor <= 853;
        59: scale_factor <= 683;
        60: scale_factor <= 512;
        61: scale_factor <= 341;
        62: scale_factor <= 171;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_13 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        57: scale_factor <= 0;
        58: scale_factor <= 171;
        59: scale_factor <= 341;
        60: scale_factor <= 512;
        61: scale_factor <= 683;
        62: scale_factor <= 853;
        // Falling edge
        63: scale_factor <= 1024;
        64: scale_factor <= 878;
        65: scale_factor <= 731;
        66: scale_factor <= 585;
        67: scale_factor <= 439;
        68: scale_factor <= 293;
        69: scale_factor <= 146;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_14 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        63: scale_factor <= 0;
        64: scale_factor <= 146;
        65: scale_factor <= 293;
        66: scale_factor <= 439;
        67: scale_factor <= 585;
        68: scale_factor <= 731;
        69: scale_factor <= 878;
        // Falling edge
        70: scale_factor <= 1024;
        71: scale_factor <= 853;
        72: scale_factor <= 683;
        73: scale_factor <= 512;
        74: scale_factor <= 341;
        75: scale_factor <= 171;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_15 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        70: scale_factor <= 0;
        71: scale_factor <= 171;
        72: scale_factor <= 341;
        73: scale_factor <= 512;
        74: scale_factor <= 683;
        75: scale_factor <= 853;
        // Falling edge
        76: scale_factor <= 1024;
        77: scale_factor <= 878;
        78: scale_factor <= 731;
        79: scale_factor <= 585;
        80: scale_factor <= 439;
        81: scale_factor <= 293;
        82: scale_factor <= 146;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_16 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        76: scale_factor <= 0;
        77: scale_factor <= 146;
        78: scale_factor <= 293;
        79: scale_factor <= 439;
        80: scale_factor <= 585;
        81: scale_factor <= 731;
        82: scale_factor <= 878;
        // Falling edge
        83: scale_factor <= 1024;
        84: scale_factor <= 878;
        85: scale_factor <= 731;
        86: scale_factor <= 585;
        87: scale_factor <= 439;
        88: scale_factor <= 293;
        89: scale_factor <= 146;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_17 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        83: scale_factor <= 0;
        84: scale_factor <= 146;
        85: scale_factor <= 293;
        86: scale_factor <= 439;
        87: scale_factor <= 585;
        88: scale_factor <= 731;
        89: scale_factor <= 878;
        // Falling edge
        90: scale_factor <= 1024;
        91: scale_factor <= 896;
        92: scale_factor <= 768;
        93: scale_factor <= 640;
        94: scale_factor <= 512;
        95: scale_factor <= 384;
        96: scale_factor <= 256;
        97: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_18 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        90: scale_factor <= 0;
        91: scale_factor <= 128;
        92: scale_factor <= 256;
        93: scale_factor <= 384;
        94: scale_factor <= 512;
        95: scale_factor <= 640;
        96: scale_factor <= 768;
        97: scale_factor <= 896;
        // Falling edge
        98: scale_factor <= 1024;
        99: scale_factor <= 896;
        100: scale_factor <= 768;
        101: scale_factor <= 640;
        102: scale_factor <= 512;
        103: scale_factor <= 384;
        104: scale_factor <= 256;
        105: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_19 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        98: scale_factor <= 0;
        99: scale_factor <= 128;
        100: scale_factor <= 256;
        101: scale_factor <= 384;
        102: scale_factor <= 512;
        103: scale_factor <= 640;
        104: scale_factor <= 768;
        105: scale_factor <= 896;
        // Falling edge
        106: scale_factor <= 1024;
        107: scale_factor <= 910;
        108: scale_factor <= 796;
        109: scale_factor <= 683;
        110: scale_factor <= 569;
        111: scale_factor <= 455;
        112: scale_factor <= 341;
        113: scale_factor <= 228;
        114: scale_factor <= 114;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_20 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        106: scale_factor <= 0;
        107: scale_factor <= 114;
        108: scale_factor <= 228;
        109: scale_factor <= 341;
        110: scale_factor <= 455;
        111: scale_factor <= 569;
        112: scale_factor <= 683;
        113: scale_factor <= 796;
        114: scale_factor <= 910;
        // Falling edge
        115: scale_factor <= 1024;
        116: scale_factor <= 896;
        117: scale_factor <= 768;
        118: scale_factor <= 640;
        119: scale_factor <= 512;
        120: scale_factor <= 384;
        121: scale_factor <= 256;
        122: scale_factor <= 128;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_21 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        115: scale_factor <= 0;
        116: scale_factor <= 128;
        117: scale_factor <= 256;
        118: scale_factor <= 384;
        119: scale_factor <= 512;
        120: scale_factor <= 640;
        121: scale_factor <= 768;
        122: scale_factor <= 896;
        // Falling edge
        123: scale_factor <= 1024;
        124: scale_factor <= 922;
        125: scale_factor <= 819;
        126: scale_factor <= 717;
        127: scale_factor <= 614;
        128: scale_factor <= 512;
        129: scale_factor <= 410;
        130: scale_factor <= 307;
        131: scale_factor <= 205;
        132: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_22 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        123: scale_factor <= 0;
        124: scale_factor <= 102;
        125: scale_factor <= 205;
        126: scale_factor <= 307;
        127: scale_factor <= 410;
        128: scale_factor <= 512;
        129: scale_factor <= 614;
        130: scale_factor <= 717;
        131: scale_factor <= 819;
        132: scale_factor <= 922;
        // Falling edge
        133: scale_factor <= 1024;
        134: scale_factor <= 922;
        135: scale_factor <= 819;
        136: scale_factor <= 717;
        137: scale_factor <= 614;
        138: scale_factor <= 512;
        139: scale_factor <= 410;
        140: scale_factor <= 307;
        141: scale_factor <= 205;
        142: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_23 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        133: scale_factor <= 0;
        134: scale_factor <= 102;
        135: scale_factor <= 205;
        136: scale_factor <= 307;
        137: scale_factor <= 410;
        138: scale_factor <= 512;
        139: scale_factor <= 614;
        140: scale_factor <= 717;
        141: scale_factor <= 819;
        142: scale_factor <= 922;
        // Falling edge
        143: scale_factor <= 1024;
        144: scale_factor <= 922;
        145: scale_factor <= 819;
        146: scale_factor <= 717;
        147: scale_factor <= 614;
        148: scale_factor <= 512;
        149: scale_factor <= 410;
        150: scale_factor <= 307;
        151: scale_factor <= 205;
        152: scale_factor <= 102;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_24 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        143: scale_factor <= 0;
        144: scale_factor <= 102;
        145: scale_factor <= 205;
        146: scale_factor <= 307;
        147: scale_factor <= 410;
        148: scale_factor <= 512;
        149: scale_factor <= 614;
        150: scale_factor <= 717;
        151: scale_factor <= 819;
        152: scale_factor <= 922;
        // Falling edge
        153: scale_factor <= 1024;
        154: scale_factor <= 931;
        155: scale_factor <= 838;
        156: scale_factor <= 745;
        157: scale_factor <= 652;
        158: scale_factor <= 559;
        159: scale_factor <= 465;
        160: scale_factor <= 372;
        161: scale_factor <= 279;
        162: scale_factor <= 186;
        163: scale_factor <= 93;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_25 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        153: scale_factor <= 0;
        154: scale_factor <= 93;
        155: scale_factor <= 186;
        156: scale_factor <= 279;
        157: scale_factor <= 372;
        158: scale_factor <= 465;
        159: scale_factor <= 559;
        160: scale_factor <= 652;
        161: scale_factor <= 745;
        162: scale_factor <= 838;
        163: scale_factor <= 931;
        // Falling edge
        164: scale_factor <= 1024;
        165: scale_factor <= 931;
        166: scale_factor <= 838;
        167: scale_factor <= 745;
        168: scale_factor <= 652;
        169: scale_factor <= 559;
        170: scale_factor <= 465;
        171: scale_factor <= 372;
        172: scale_factor <= 279;
        173: scale_factor <= 186;
        174: scale_factor <= 93;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_26 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        164: scale_factor <= 0;
        165: scale_factor <= 93;
        166: scale_factor <= 186;
        167: scale_factor <= 279;
        168: scale_factor <= 372;
        169: scale_factor <= 465;
        170: scale_factor <= 559;
        171: scale_factor <= 652;
        172: scale_factor <= 745;
        173: scale_factor <= 838;
        174: scale_factor <= 931;
        // Falling edge
        175: scale_factor <= 1024;
        176: scale_factor <= 939;
        177: scale_factor <= 853;
        178: scale_factor <= 768;
        179: scale_factor <= 683;
        180: scale_factor <= 597;
        181: scale_factor <= 512;
        182: scale_factor <= 427;
        183: scale_factor <= 341;
        184: scale_factor <= 256;
        185: scale_factor <= 171;
        186: scale_factor <= 85;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_27 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        175: scale_factor <= 0;
        176: scale_factor <= 85;
        177: scale_factor <= 171;
        178: scale_factor <= 256;
        179: scale_factor <= 341;
        180: scale_factor <= 427;
        181: scale_factor <= 512;
        182: scale_factor <= 597;
        183: scale_factor <= 683;
        184: scale_factor <= 768;
        185: scale_factor <= 853;
        186: scale_factor <= 939;
        // Falling edge
        187: scale_factor <= 1024;
        188: scale_factor <= 945;
        189: scale_factor <= 866;
        190: scale_factor <= 788;
        191: scale_factor <= 709;
        192: scale_factor <= 630;
        193: scale_factor <= 551;
        194: scale_factor <= 473;
        195: scale_factor <= 394;
        196: scale_factor <= 315;
        197: scale_factor <= 236;
        198: scale_factor <= 158;
        199: scale_factor <= 79;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_28 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        187: scale_factor <= 0;
        188: scale_factor <= 79;
        189: scale_factor <= 158;
        190: scale_factor <= 236;
        191: scale_factor <= 315;
        192: scale_factor <= 394;
        193: scale_factor <= 473;
        194: scale_factor <= 551;
        195: scale_factor <= 630;
        196: scale_factor <= 709;
        197: scale_factor <= 788;
        198: scale_factor <= 866;
        199: scale_factor <= 945;
        // Falling edge
        200: scale_factor <= 1024;
        201: scale_factor <= 945;
        202: scale_factor <= 866;
        203: scale_factor <= 788;
        204: scale_factor <= 709;
        205: scale_factor <= 630;
        206: scale_factor <= 551;
        207: scale_factor <= 473;
        208: scale_factor <= 394;
        209: scale_factor <= 315;
        210: scale_factor <= 236;
        211: scale_factor <= 158;
        212: scale_factor <= 79;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_29 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        200: scale_factor <= 0;
        201: scale_factor <= 79;
        202: scale_factor <= 158;
        203: scale_factor <= 236;
        204: scale_factor <= 315;
        205: scale_factor <= 394;
        206: scale_factor <= 473;
        207: scale_factor <= 551;
        208: scale_factor <= 630;
        209: scale_factor <= 709;
        210: scale_factor <= 788;
        211: scale_factor <= 866;
        212: scale_factor <= 945;
        // Falling edge
        213: scale_factor <= 1024;
        214: scale_factor <= 951;
        215: scale_factor <= 878;
        216: scale_factor <= 805;
        217: scale_factor <= 731;
        218: scale_factor <= 658;
        219: scale_factor <= 585;
        220: scale_factor <= 512;
        221: scale_factor <= 439;
        222: scale_factor <= 366;
        223: scale_factor <= 293;
        224: scale_factor <= 219;
        225: scale_factor <= 146;
        226: scale_factor <= 73;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_30 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        213: scale_factor <= 0;
        214: scale_factor <= 73;
        215: scale_factor <= 146;
        216: scale_factor <= 219;
        217: scale_factor <= 293;
        218: scale_factor <= 366;
        219: scale_factor <= 439;
        220: scale_factor <= 512;
        221: scale_factor <= 585;
        222: scale_factor <= 658;
        223: scale_factor <= 731;
        224: scale_factor <= 805;
        225: scale_factor <= 878;
        226: scale_factor <= 951;
        // Falling edge
        227: scale_factor <= 1024;
        228: scale_factor <= 951;
        229: scale_factor <= 878;
        230: scale_factor <= 805;
        231: scale_factor <= 731;
        232: scale_factor <= 658;
        233: scale_factor <= 585;
        234: scale_factor <= 512;
        235: scale_factor <= 439;
        236: scale_factor <= 366;
        237: scale_factor <= 293;
        238: scale_factor <= 219;
        239: scale_factor <= 146;
        240: scale_factor <= 73;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


module triangular_filter_31 (
  input wire clk_in,
  input wire rst_in,

  input wire [31:0] power_in,
  input wire [8:0] k_in,
  output logic [31:0] filtered_out
);

  logic [10:0] scale_factor;
  logic [21:0] power_buffer;

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      scale_factor <= 0;
      power_buffer <= 0;
      filtered_out <= 0;
    end else begin
      // Pipeline stage 1
      power_buffer <= power_in[31:10];
      case (k_in)
        // Rising edge
        227: scale_factor <= 0;
        228: scale_factor <= 73;
        229: scale_factor <= 146;
        230: scale_factor <= 219;
        231: scale_factor <= 293;
        232: scale_factor <= 366;
        233: scale_factor <= 439;
        234: scale_factor <= 512;
        235: scale_factor <= 585;
        236: scale_factor <= 658;
        237: scale_factor <= 731;
        238: scale_factor <= 805;
        239: scale_factor <= 878;
        240: scale_factor <= 951;
        // Falling edge
        241: scale_factor <= 1024;
        242: scale_factor <= 956;
        243: scale_factor <= 887;
        244: scale_factor <= 819;
        245: scale_factor <= 751;
        246: scale_factor <= 683;
        247: scale_factor <= 614;
        248: scale_factor <= 546;
        249: scale_factor <= 478;
        250: scale_factor <= 410;
        251: scale_factor <= 341;
        252: scale_factor <= 273;
        253: scale_factor <= 205;
        254: scale_factor <= 137;
        255: scale_factor <= 68;
        default: scale_factor <= 0;
      endcase
      // Pipeline stage 2
      filtered_out <= power_buffer * scale_factor;
    end
  end
endmodule


`default_nettype wire
