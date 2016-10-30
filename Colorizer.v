///////////////////////////////////////////////////////

//Designed a colorizer module which takes two pixel information from 
//the Bot module and Icon Module and gives a 12 bit output in the form of 
//RGB combination.

//  world_pixel[1:0]    icon[1:0]      color
//    00                   00         background
//    01                   00         blackline
//    10                   00         obstruction
//    11                   00         reserved
//    xx                   01         icon color 1
//    xx                   10         icon color 2
//    xx                   11         icon color 3



//////////////////////////////////////////////////////
module Colorizer(
input Clock, Reset,
input [1:0] World_px,
input [1:0] Icon_px,
input Video_on,
output reg [3:0] red, green, blue) ;


parameter background = 12'hfff;
parameter blackline = 12'h000;
parameter obstruction = 12'h00f; // blue color for obstruction
parameter icon1 = 12'hff0; // yellow
parameter icon2 = 12'h000; // black for an eye of packman


always @(posedge Clock)
begin
	if(Video_on)
	begin
		if(Icon_px == 2'd0)
		begin
	
			case(World_px)
			2'd0: {red,green,blue} <= background;
			2'd1: {red,green,blue}  <= blackline;
			2'd2: {red,green,blue} <= obstruction;
			default: {red,green,blue} <= {red,green,blue};
			endcase
		end
		else if(Icon_px == 2'd1)
				{red,green,blue} <= icon1;
		else if (Icon_px == 2'd2)
				{red,green,blue} <= icon2;
		else
				{red,green,blue} <= {red,green,blue};
	end
	else
			{red,green,blue}  <= blackline;
end
endmodule

