//instansiation
module top_reciever(
input wire clk,rest,
input wire rx_in,
input wire par_en ,
input wire [4:0]prescale,
input wire par_typ,
output wire d_valid,
output wire [7:0]p_data
);


//internal connections
wire dat_samp_en ;
wire [4:0]edge_cnt ;
wire [3:0]bit_cnt ;
wire enable;
wire sampled_bit;
wire deslz_en;
wire stp_err;
wire stp_chk_en;
wire strt_glitch;
wire strt_chk_en;
wire par_err;
wire par_chk_en;




fsm_rx u_fsm(
.clk(clk),
.rest(rest),
.rx_in(rx_in),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt),
.par_err(par_err),
.par_en(par_en),
.strt_glitch(strt_glitch),
.stp_err(stp_err),
.par_typ(par_typ),
.dat_samp_en(dat_samp_en),
.enable(enable),
.deslz_en(deslz_en),
.d_valid(d_valid),
.stp_chk_en(stp_chk_en),
.strt_chk_en(strt_chk_en),
.par_chk_en(par_chk_en)
);



edge_bit_counter u_edge_bit_counter(
.clk(clk),
.rest(rest),
.enable(enable),
.prescale(prescale),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt)
);


deserializer u_deserializer(
.clk(clk),
.rest(rest),
.deslz_en(deslz_en),
.edge_cnt(edge_cnt),
.sampled_bit(sampled_bit),
.p_data(p_data)
);



stop_check u_stop_check(
.clk(clk),
.sampled_bit(sampled_bit),
.stp_chk_en(stp_chk_en),
.stp_err(stp_err)
);


strt_check u_strt_check(
.clk(clk),
.sampled_bit(sampled_bit),
.strt_chk_en(strt_chk_en),
.strt_glitch(strt_glitch)
);


parity_check u_parity_check(
.clk(clk),
.sampled_bit(sampled_bit),
.par_typ(par_typ),
.p_data(p_data),
.par_chk_en(par_chk_en),
.par_err(par_err)
);


sampling_data u_sampling_data(
.clk(clk),
.dat_samp_en(dat_samp_en),
.prescale(prescale),
.sample1(sample1),
.sample2(sample2),
.sample3(sample3),
.rx_in(rx_in),
.edge_cnt(edge_cnt),
.sampled_bit(sampled_bit)
);

endmodule