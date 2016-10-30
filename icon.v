module Icon(
input vga_clock,
input [7:0] LocX,
input [7:0] LocY, 
input [7:0]Botinfo,
input [9:0] Rowpx,Colpx,
output reg [1:0] icon );


reg [3:0] rowaddr, coladdr;
wire [1:0] data_out;
reg [11:0] romaddr;

Icon_Rom memory(
.clka(vga_clock),
.addra(romaddr),
.douta(data_out)
) ;


always @ (posedge vga_clock)
begin
	rowaddr <= Rowpx - LocY;
	coladdr <= Colpx - LocX;
	romaddr <= {Botinfo,rowaddr,coladdr};
	
	if(reset)
			icon <= 2'b00;
	else if((rowaddr >= 0 && coladdr >= 0) && (rowaddr < 16 && coladdr < 16 ))
			icon <= data_out;
	else
			icon <= 2'b00;
		


end
endmodule


