module mux (
input wire [4:0] mux_sel,
input wire ser_data, 
input wire par_bit_x ,
output reg tx_out
);
localparam [2:0] idle = 3'b000 ,
                 start= 3'b001 ,
				 data = 3'b011 ,
			  par_bit = 3'b010 ,
				 stop = 3'b110 ;
always @(*)
begin 
 if (mux_sel == start )
    tx_out = 1'b0 ;
 else if (mux_sel== data)
    tx_out = ser_data ;
 else if (mux_sel == par_bit)
    tx_out = par_bit_x ;
 else
  tx_out = 1'b1 ;
end
endmodule 

