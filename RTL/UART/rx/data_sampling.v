module sampling_data(
input wire clk,
input wire dat_samp_en,
input wire rx_in,
input wire [4:0] edge_cnt,
input wire [4:0]prescale,
output reg sample1 ,sample2 , sample3,
output reg sampled_bit
);


always@(posedge clk)
begin
  if(dat_samp_en && edge_cnt ==( prescale>>1)-1)
    sample1 <= rx_in;
  else if (dat_samp_en&& edge_cnt == prescale>>1)//
    sample2 <= rx_in;
  else if (dat_samp_en&& edge_cnt == (prescale>>1)+1)
    sample3 <= rx_in ;
end

always@(*)
begin
   sampled_bit = (sample1 & sample2) | (sample1 & sample3) | (sample2 & sample3);
end
endmodule 
