module Icon(
input vga_clock,
input reset,
input [7:0] LocX,
input [7:0] LocY, 
input [7:0]Botinfo,
input [9:0] Rowpx,Colpx,
output reg [1:0] icon );

wire [9:0] Locx_reg, Locy_reg; 

reg signed [10:0] rowaddr, coladdr;
wire [1:0] data_out;
reg [10:0] romaddr;

Icon_Rom memory(
.clka(vga_clock),
.addra(romaddr),
.douta(data_out)
) ;

assign Locx_reg = {LocX,2'b00};
assign Locy_reg = {LocY, 2'b00};

always @ (posedge vga_clock)
begin
	rowaddr <= Rowpx - Locy_reg + 8;
	coladdr <= Colpx - Locx_reg + 8;
	romaddr <= {Botinfo[2:0],rowaddr[3:0],coladdr[3:0]};
	
	if(reset)
			icon <= 2'b00;
	else if((rowaddr >= 0 && coladdr >= 0) && (rowaddr < 16 && coladdr < 16 ))
			icon <= data_out;
	else
			icon <= 2'b00;
		


end
endmodule


