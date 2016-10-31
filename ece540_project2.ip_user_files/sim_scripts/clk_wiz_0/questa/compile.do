vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../ipstatic/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/Kyle Thompson/Projects/GradSchool/ECE540/project2/project2/ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/Kyle Thompson/Projects/GradSchool/ECE540/project2/project2/ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_v5_3_1" \
"C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 \
"C:/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/Kyle Thompson/Projects/GradSchool/ECE540/project2/project2/ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/clk_wiz_v5_3_1" "+incdir+../../../ipstatic/Kyle Thompson/Projects/GradSchool/ECE540/project2/project2/ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_v5_3_1" \
"../../../../ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../../ece540_project2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \

vlog -work xil_defaultlib "glbl.v"

