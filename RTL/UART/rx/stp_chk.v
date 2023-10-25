module stop_check(
input wire clk,
input wire sampled_bit,
input wire stp_chk_en,
output reg stp_err
);


always@(posedge clk)
begin
   if (stp_chk_en && sampled_bit)
       stp_err <= 1'b0;
	else if(stp_chk_en && !sampled_bit)
	   stp_err <= 1'b1;
end
endmodule	   