module SYS_CTRL_tx	 
 (
input wire CLK,
input wire RST,
input wire [7:0] ALU_OUT,
input wire OUT_Valid,
input wire [7:0] RdData,
input wire RdData_Valid,
input wire Busy,
output reg [7:0] TX_P_DATA,
output reg TX_D_VLD
);    	
   
localparam [1:0]   IDLE   = 2'b00 ,
                   Rd_St  = 2'b01 ,
                   FUN_St = 2'b11 ;
			
				   
				   
reg  [1:0]      next_state , current_state ;
 
 always@(posedge CLK , negedge RST)
begin 
if(!RST)
   begin 
	      current_state <= IDLE ;
		end
	else 
	   begin 
	      current_state <= next_state ;
	    end 
end


always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                TX_P_DATA <= 0;
                TX_D_VLD  <= 0;
            end
        else
            begin
                if (OUT_Valid)
                    begin
                        TX_P_DATA <= ALU_OUT;
                        TX_D_VLD  <= 1;
                    end
                else if (RdData_Valid)
                    begin
                        TX_P_DATA <= RdData;
                        TX_D_VLD  <= 1;
                    end
                else if (Busy)
                    begin
                        TX_P_DATA <= 0;
                        TX_D_VLD  <= 0;
                    end
            end
    end

endmodule