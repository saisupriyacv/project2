// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Sun Oct 30 16:31:21 2016
// Host        : LAPTOP-KYLE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Kyle
//               Thompson/Projects/GradSchool/ECE540/project2/project2/ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v}
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_in1, sysclk, vga_clk, reset, locked)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,sysclk,vga_clk,reset,locked" */;
  input clk_in1;
  output sysclk;
  output vga_clk;
  input reset;
  output locked;
endmodule
