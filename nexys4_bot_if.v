module nexys4_bot_if#( parameter integer Reset_polarity_low =  	1)(
input [4:1] dbbtns,
input [7:0] Sw_07_00,
input [15:0] Sw_15_08,
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
output reg [7:0]  LEDS_07_00,
output  reg [7:0] LEDS_15_08);



always @ (posedge sysclk) begin
case (port_id[4:0])

5'h0 : io_data_out <= dbbtns;
5'h1 : io_data_out <= Sw_07_00;
5'h2 : io_data_out <= LEDS_07_00;
5'h3 : io_data_out <= dig3;
5'h4: io_data_out <= dig2;
5'h5: io_data_out <= dig1;
5'h6: io_data_out <= dig0;
5'h7: io_data_out <= dp[3:0];
5'h9: io_data_out <= MotCtl;
5'hA: io_data_out <= locx;
5'hB: io_data_out <= locy;
5'hC: io_data_out <= botinfo;
5'hD: io_data_out <= sensors;
5'hE: io_data_out <= lmdist;
5'hF: io_data_out <= rmdist;
5'h10: io_data_out <= dbbtns;
5'h11: io_data_out <= Sw_15_08;
5'h12: io_data_out <= LEDS_15_08;
5'h13: io_data_out <= dig7;
5'h14: io_data_out <= dig6;
5'h15: io_data_out <= dig5;
5'h16: io_data_out <= dig4;
5'h17: io_data_out <= dp[7:4];
default : io_data_out <= 8'bXXXXXXXX ;
endcase
end


always @ (posedge sysclk)
begin
// 'write_strobe' is used to qualify all writes to general output ports.
	if (write_strobe == 1'b1)
	begin
// Write to LEDS[7:0] at port address 01 hex
		if (port_id[4:0] == 5'h9) 
		begin
			MotCtl <= io_data_in;
		end
// Write to LEDS[15:8] at port address 02 hex
		else if (port_id[4:0] == 5'h13) 
		begin
			dig7 <= io_data_in;
		end
		else if (port_id[4:0] == 5'h14) 
		begin
			dig6 <= io_data_in;
		end
		else if (port_id[4:0] == 5'h15) 
		begin
			dig5 <= io_data_in;
		end
		else if (port_id[4:0] == 5'h16) 
		begin
			dig4 <= io_data_in;
		end

		else if (port_id[4:0] == 5'h3) 
		begin
			dig3 <= io_data_in;
		end
		else if (port_id[4:0] == 5'h4)
		begin 
			dig2 <= io_data_in;
		
		end
		else if (port_id[4:0] == 5'h5)
		begin
			dig1 <= io_data_in;
		
		end
		else if (port_id[4:0] == 5'h6)
		begin
			dig0 <= io_data_in;
		
		end
		else if (port_id[4:0] == 5'h7)
		begin
			dp[3:0] <= io_data_in;
		
		end
		else if (port_id[4:0] == 5'h17)
		begin
			dp[7:4] <= io_data_in;
		end 
		else if (port_id[4:0] == 5'h2)
		begin
			LEDS_07_00 <= io_data_in;
		end
		else if (port_id[4:0] == 5'h12)
		begin
			LEDS_15_08 <= io_data_in;
		end
		
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