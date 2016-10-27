module nexys4_bot_if#( parameter integer Reset_polarity_low = 0 )(
input [5:0] dbbtns,
input [15:0] Switches,
input k_write_strobe,
input write_strobe, // Write strobe - asserted to write I/O data
input read_strobe, // Read strobe - asserted to read I/O data
input [7:0] port_id, // I/O port address
input [7:0] io_data_in, 
output reg [7:0] io_data_out,

input interrupt_ack, // interrupt acknowledge from PicoBlaze
output reg interrupt, // interrupt request to PicoBlaze

//nexysd fpga 
input sysclk,sysreset,
input [7:0] locx,
input [7:0] locy,
input [7:0] botinfo,
input [7:0] sensors,
input [7:0] lmdist,
input [7:0] rmdist,
input upd_sysregs,

output 		reg [7:0]		MotCtl,
output  	reg [4:0]		dig7, dig6,
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0,
output reg [7:0] dp,
output reg [15:0]  LEDS);



always @ (posedge sysclk) begin
case (port_id[7:0])

8'h0 : io_data_out <= {4'b0000,dbbtns[3:0]};
8'h1 : io_data_out <= Switches[7:0];
8'h2 : io_data_out <= LEDS[7:0];
8'h3 : io_data_out <= {3'b000,dig3};
8'h4: io_data_out <= {3'b000,dig2};
8'h5: io_data_out <= {3'b000,dig1};
8'h6: io_data_out <= {3'b000,dig0};
8'h7: io_data_out <= {4'b0000,dp[3:0]};
8'h9: io_data_out <= MotCtl;
8'hA: io_data_out <= locx;
8'hB: io_data_out <= locy;
8'hC: io_data_out <= botinfo;
8'hD: io_data_out <= sensors;
8'hE: io_data_out <= lmdist;
8'hF: io_data_out <= rmdist;
8'h10: io_data_out <= dbbtns;
8'h11: io_data_out <= Switches[15:8];
8'h12: io_data_out <= LEDS[15:8];
8'h13: io_data_out <= {3'b000,dig7};
8'h14: io_data_out <= {3'b000,dig6};
8'h15: io_data_out <= {3'b000,dig5};
8'h16: io_data_out <= {3'b000,dig4};
8'h17: io_data_out <= {4'b0000,dp[7:4]};
default : io_data_out <= 8'bXXXXXXXX ;
endcase
end


always @ (posedge sysclk or posedge sysreset)
begin
// 'write_strobe' is used to qualify all writes to general output ports.
	if (write_strobe == 1'b1)
	begin
// Write to LEDS[7:0] at port address 01 hex
		case (port_id[7:0])
		8'h2: LEDS[7:0] <= io_data_in;
		8'h3: dig3 <= io_data_in[4:0];
		8'h4: dig2 <= io_data_in[4:0];
		8'h5: dig1 <= io_data_in[4:0];
		8'h6: dig0 <= io_data_in[4:0];
		8'h7: dp[3:0] <= io_data_in[3:0];
		8'h9: MotCtl <= io_data_in;
		8'h12: LEDS[15:8] <= io_data_in;
		8'h13: dig7 <= io_data_in[4:0];
		8'h14: dig6 <= io_data_in[4:0];
		8'h15: dig5 <= io_data_in[4:0];
		8'h16: dig4 <= io_data_in[4:0];
		8'h17: dp[7:4] <= io_data_in[7:4];
		
		
		endcase
		
	end
	else if(sysreset == 1'b1) begin
		
		dig7 <= 5'b11111;
		dig6 <= 5'b01110;
		dig5 <= 5'b01100;
		dig4 <= 5'b01110;
		dig3 <= 5'b00101;
		dig2 <= 5'b00100;
		dig1 <= 5'b00000;
		dig0 <= 5'b11111;
		dp <= 8'b00;
	end
	
end

//Interrupt Handler
always @ (posedge sysclk) begin
if (interrupt_ack == 1'b1) begin
interrupt <= 1'b0;
end
else if (upd_sysregs == 1'b1) begin
interrupt <= 1'b1;
end
else begin
interrupt <= interrupt;
end
end // always

endmodule