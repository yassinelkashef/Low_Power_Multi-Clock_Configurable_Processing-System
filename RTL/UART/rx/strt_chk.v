module strt_check(
input wire clk,
input wire sampled_bit,
input wire strt_chk_en,
output reg strt_glitch
);


always@(posedge clk)
begin
   if(strt_chk_en && !sampled_bit)
      strt_glitch <= 1'b0 ;
else if(strt_chk_en && sampled_bit)
      strt_glitch <= 1'b1 ;
end
endmodule

