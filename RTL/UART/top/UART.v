module UART_TOP 
(
 input   wire                          RST,
 input   wire                          TX_CLK,
 input   wire                          RX_CLK,
 input   wire                          RX_IN_S,
 output  wire   [7:0]                  RX_OUT_P, 
 output  wire                          RX_OUT_V,
 input   wire   [7:0]                  TX_IN_P, 
 input   wire                          TX_IN_V, 
 output  wire                          TX_OUT_S,
 output  wire                          TX_OUT_Busy,  
 input   wire   [4:0]                  Prescale,
 input   wire                          parity_enable,
 input   wire                          parity_type
);


TOP_TX U0_UART_TX (
.clk(TX_CLK),
.rest(RST),
.p_data(TX_IN_P),
.d_valid(TX_IN_V),
.par_en(parity_enable),
.par_typ(parity_type), 
.tx_out(TX_OUT_S),
.busy(TX_OUT_Busy)
);
 
 
top_reciever U0_UART_RX (
.clk(RX_CLK),
.rest(RST),
.rx_in(RX_IN_S),
.prescale(Prescale),
.par_en(parity_enable),
.par_typ(parity_type),
.p_data(RX_OUT_P), 
.d_valid(RX_OUT_V)
);
endmodule