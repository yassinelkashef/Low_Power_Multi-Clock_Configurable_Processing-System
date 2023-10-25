
	
module SYS_CTRL
(
input     wire             CLK,        ///////////
input     wire             RST,
input     wire [7:0]       RX_P_DATA,
input     wire             RX_D_VLD,
input     wire [7:0]      ALU_OUT,
input     wire             OUT_Valid,
input     wire [7:0]       RdData,
input     wire             RdData_Valid,
input     wire             TX_OUT_Busy,
output    wire             EN,
output    wire [3:0]       ALU_FUN,
output    wire             CLK_EN, 
output    wire [3:0]       Address,
output    wire             WrEn,
output    wire             RdEn,
output    wire [7:0]       WrData,
output    wire [7:0]       TX_P_DATA,
output    wire             TX_D_VLD

);	  


SYS_CTRL_rx U0_SYS_CTRL_rx  (
.CLK(CLK),
.RST(RST),
.RX_P_DATA(RX_P_DATA),
.RX_D_VLD(RX_D_VLD),
.EN(EN),
.ALU_FUN(ALU_FUN),
.CLK_EN(CLK_EN),
.Address(Address),
.WrEn(WrEn),
.RdEn(RdEn),
.WrData(WrData)
);



SYS_CTRL_tx U0_SYS_CTRL_tx (
.CLK(CLK),
.RST(RST),
.ALU_OUT( ALU_OUT),
.OUT_Valid(OUT_Valid),
.RdData(RdData),
.RdData_Valid(RdData_Valid),
.Busy(TX_OUT_Busy),
.TX_P_DATA(TX_P_DATA),
.TX_D_VLD( TX_D_VLD)
 );
 
 endmodule



   