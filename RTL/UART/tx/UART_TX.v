
//instansiation

module TOP_TX(
input wire clk,rest,
input wire par_en,
input wire d_valid,
input wire par_typ,
input wire [7:0] p_data,
output wire tx_out,
output wire busy 
);

//internal connections
wire ser_data ;
wire ser_dn ;
wire ser_en;
wire [4:0]mux_sel ;
wire par_bit ;




serializer u_serializer (
.clk(clk),
.rest(rest),
.p_data(p_data),
.ser_en(ser_en),
.ser_dn(ser_dn),
.ser_data(ser_data)
);



fsm_tx u_fsm(
.clk(clk),
.rest(rest),
.d_valid(d_valid),
.par_en(par_en),
.ser_dn(ser_dn),
.ser_en(ser_en),
.mux_sel(mux_sel),
.busy(busy)
);


par_calc u_par_calc(
.clk(clk),
.p_data(p_data),
.d_valid(d_valid),
.par_typ(par_typ),
.par_bit_x(par_bit_x)
);

mux u_mux(
.mux_sel(mux_sel),
.par_bit_x(par_bit_x),
.ser_data(ser_data),
.tx_out(tx_out)
);
endmodule



