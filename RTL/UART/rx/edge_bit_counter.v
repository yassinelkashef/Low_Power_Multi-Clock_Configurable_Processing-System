module edge_bit_counter(
input wire clk,
input wire rest,
input wire enable,
input wire [4:0] prescale,
output reg[4:0] edge_cnt,
output reg [3:0] bit_cnt
);


always@(posedge clk , negedge rest )
begin 
     if(!rest)
	         begin
			    edge_cnt<= 5'b0;
				bit_cnt <= 4'b0;
			 end
	else if(enable)
	         begin
			    edge_cnt <= edge_cnt + 1 ;
		     
			if(edge_cnt==prescale)
			  begin
			     edge_cnt <= 5'b1 ;
			     bit_cnt <= bit_cnt + 1;
			  end
              end			
            else   
              begin
			    edge_cnt<= 5'b0;
				bit_cnt <= 4'b0;
			 end
end
endmodule
			  
			  