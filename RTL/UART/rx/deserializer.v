module deserializer(
input wire clk,
input wire rest,
input wire sampled_bit,
input wire deslz_en,
input wire [4:0]edge_cnt,
output reg [7:0]p_data
);


always@(posedge clk , negedge rest)
begin  
   if (!rest)
       begin
            p_data <= 8'b0 ;
	   end
   else if (deslz_en&&edge_cnt==5'b111)
       begin
            p_data <= {sampled_bit,p_data[7:1]};/////////////
       end
    
end 
endmodule	   


