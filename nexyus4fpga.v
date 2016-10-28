
module Nexys4fpga (
	input 				clk,                // 100MHz clock from on-board oscillator
	input				btnL, btnR,				// pushbutton inputs - left (db_btns[4])and right (db_btns[2])
	input				btnU, btnD,				// pushbutton inputs - up (db_btns[3]) and down (db_btns[1])
	input				btnC,					// pushbutton inputs - center button -> db_btns[5]
	input				btnCpuReset,			// red pushbutton input -> db_btns[0]
	
	input	[15:0]		sw,						// switch inputs
	
	output	 [15:0]		led,  					// LED outputs	
	
	output 	[6:0]		seg,					// Seven segment display cathode pins
	output              dp,
	output	[7:0]		an,						// Seven segment display anode pins	
	
	
	output	[7:0]		JA						// JA Header 
);	
	// parameter
	parameter SIMULATE = 0;
	
	wire   [9:0]		vid_row;
	wire   [9:0]		vid_col;
	wire  [1:0]		vid_pixel_out;
	wire 	[15:0]		db_sw;					// debounced switches
	wire 	[5:0]		db_btns;				// debounced buttons
	wire 	[4:0]		dig7, dig6,
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0;				// display digits
	wire 	[7:0]		decpts;	
	wire    [7:0]       segs_int;
	wire				sysclk;					// 100MHz clock from on-board oscillator	
	wire				sysreset;	
	wire 	[63:0]		digits_out;
	wire	[11:0]		address;
	wire	[17:0]		instruction;
	wire				bram_enable;
	wire	[7:0]		port_id;
	wire	[7:0]		out_port;
	wire	 	[7:0]		in_port;
	wire				write_strobe;
	wire				k_write_strobe;
	wire				read_strobe;
	wire					interrupt;           
	wire				interrupt_ack;
	wire				kcpsm6_sleep;        
	wire					kcpsm6_reset;         
	wire 				cpu_reset;
	wire 				rdl;
	wire 				int_request;
	wire 	[7:0]		MotCtl_in;
	wire	[7:0]		Sensors_reg;
	wire	[7:0]		BotInfo_reg;
	wire	[7:0]		LocX_reg;
	wire	[7:0]		LocY_reg;
	wire	[7:0]		LMDist_reg;
	wire	[7:0]		RMDist_reg;
	wire				upd_sysregs;

// setup the intial display 
	/*assign	dig7 = {5'd00};					// intially display all zeros
	assign	dig6 = {5'd00};
	assign	dig5 = {5'd00};
	assign	dig4 = {5'd00};
	assign	dig3 = {5'd00};
	assign	dig2 = {5'd00};
	assign 	dig1 = {5'd00};
	assign	dig0 = {5'd00};*/
	//assign	decpts = 8'b00000001;			// d0 is on
	//assign	led = db_sw;					// leds show the debounced switches

		
	// global assigns
	assign	sysclk = clk;
	assign 	sysreset = ~db_btns[0]; // btnCpuReset is asserted low
	
	//assign dp = segs_int[7];
	assign seg = segs_int[6:0];
	
	assign	JA = {sysclk, sysreset, 6'b000000};  
	// instantiate the PicoBlaze and instruction ROM
	assign kcpsm6_sleep = 1'b0;
	assign kcpsm6_reset = sysreset | rdl;
	//instantiate the debounce module
	debounce
	#(
		.RESET_POLARITY_LOW(1),
		.SIMULATE(SIMULATE)
	)  	DB
	(
		.clk(sysclk),	
		.pbtn_in({btnC,btnL,btnU,btnR,btnD,btnCpuReset}),
		.switch_in(sw),
		.pbtn_db(db_btns),
		.swtch_db(db_sw)
	);	
		
// instantiate the 7-segment, 8-digit display
	sevensegment
	#(
		.RESET_POLARITY_LOW(0),
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

/////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate KCPSM6 and connect to Program Memory
 /////////////////////////////////////////////////////////////////////////////////////////
 

  kcpsm6 #(
	.interrupt_vector	(12'h3FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h00))
  processor (
	.address 		(address),
	.instruction 	(instruction),
	.bram_enable 	(bram_enable),
	.port_id 		(port_id),
	.write_strobe 	(write_strobe),
	.k_write_strobe 	(k_write_strobe),
	.out_port 		(out_port),
	.read_strobe 	(read_strobe),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 			(kcpsm6_reset),
	.sleep			(kcpsm6_sleep),
	.clk 			(sysclk)
	); 
	
//instantiate Project2Demo module
	
proj2demo #(
	.C_FAMILY		   ("7S"),   	//Family 'S6' or 'V6'
	.C_RAM_SIZE_KWORDS	(2),     	//Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(1)		//Include JTAG Loader when set to 1'b1 
	)     	
  proj2demo (    		       	
 	.rdl 			(rdl),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(sysclk)
	);

//instantiate Bot Module

bot bot1(
	.MotCtl_in		(MotCtl_in),
	.LocX_reg		(LocX_reg),
	.LocY_reg		(LocY_reg),
	.Sensors_reg	(Sensors_reg),
	.BotInfo_reg	(BotInfo_reg),
	.LMDist_reg		(LMDist_reg),
	.RMDist_reg		(RMDist_reg),
	.vid_row		(vid_row),
	.vid_col		(vid_col),
	.vid_pixel_out	(vid_pixel_out),
	.reset			(sysreset),
	.clk			(sysclk),
	.upd_sysregs(upd_sysregs)
);

//instantiate I/O Interface

nexys4_bot_if #( .Reset_polarity_low(0) )
bot_if(
	.dbbtns({2'b00,db_btns[4:1]}),
	.Switches(sw),
	.k_write_strobe(k_write_strobe),
	.write_strobe(write_strobe),
	.read_strobe(read_strobe),
	.port_id(port_id),
	.io_data_in(out_port),
	.io_data_out(in_port),
	.interrupt_ack(interrupt_ack),
	.interrupt(interrupt),
	.sysclk(sysclk),
	.sysreset(sysreset),
	.locx(LocX_reg),
	.locy(LocY_reg),
	.botinfo(BotInfo_reg),
	.sensors(Sensors_reg),
	.lmdist(LMDist_reg),
	.rmdist(RMDist_reg),
	.upd_sysregs(upd_sysregs),
	.MotCtl(MotCtl_in),
	.dig7(dig7),
	.dig6(dig6),
	.dig5(dig5),
	.dig4(dig4),
	.dig3(dig3),
	.dig2(dig2),
	.dig1(dig1),
	.dig0(dig0),
	.dp(decpts),
	.LEDS(led));
	
 endmodule
 
 
 
 
 
 