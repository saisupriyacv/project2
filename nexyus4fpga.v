module nexyus4fpga(	input clk, input	btnCpuReset,,output	[7:0]		an	)

wire 	[4:0]		dig7, dig6,
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0;				// display digits
wire 	[7:0]		decpts;
wire    [7:0]       segs_int; 

wire an;
wire sysclk;
wire 	[63:0]		digits_out;				// ASCII digits (Only for Simulation)

wire 	[5:0]		db_btns;

assign sysclk = clk;
assign sysreset = db_btns[0];


sevensegment
	#(
		.RESET_POLARITY_LOW(1),
		.SIMULATE(SIMULATE)
	) SSB
	(
		// inputs for control signals
		.d0(dig0),
		.d1(dig1),
 		.d2(dig2),
		.d3(dig3),
		.d4(dig4),
		.d5(dig5),
		.d6(dig6),
		.d7(dig7),
		.dp(decpts),
		
		// outputs to seven segment display
		.seg(segs_int),			
		.an(an),
		
		// clock and reset signals (100 MHz clock, active high reset)
		.clk(sysclk),
		.reset(sysreset),
		
		// ouput for simulation only
		.digits_out(digits_out)
	);




)



endmodule