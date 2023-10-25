`timescale 1ns/1ps
module SYS_TOp_tb();

//tb signals
reg                  REF_CLK_tb ;
reg                  RST_tb;
reg                  UART_CLK_tb;
wire                  RX_IN_tb;
wire                 TX_OUT_tb;        ////////////


//USER UART INSTANTIATION 


reg           UART_TX_CLK_USER;
reg    [7:0]  UART_TX_P_USER;
reg           UART_TX_V_USER;
reg    [4:0]  prescale_USER;
reg           parity_enable_USER;
reg           parity_type_USER;
wire   [7:0]  UART_RX_OUT_P_USER;
wire          UART_RX_V_OUT_USER;
wire          TX_OUT_Busy_USER;



localparam          SYS_PER     =       20,
                    H_SYS_PER   =       10,
                    UART_PER    =       12755.02,
                    H_UART_PER  =       6377.551,
                    TX_PER      =       104166.666,
                    H_TX_PER    =       52083.333;
					
					
localparam  RF_Write    =   8'hAA,
            RF_Read     =   8'hBB,
            ALU_Op      =   8'hCC,
            ALU_No_Op   =   8'hDD;

			

localparam  ADD    =   4'b0000,
            SUB    =   4'b0001,
            MUL    =   4'b0010,
            DIV    =   4'b0011,
            AND    =   4'b0100,
            OR     =   4'b0101,
            NAND   =   4'b0110,
            NOR    =   4'b0111,
            XOR    =   4'b1000,
            XNOR   =   4'b1001,
            EQU    =   4'b1010,
            GRT    =   4'b1011,
            LESS   =   4'b1100,
            SHR    =   4'b1101,
            SHL    =   4'b1110;
   
//Tasks
task    Send_Frame;
    input   [7:0]   frame;
    integer I;
    begin
       #TX_PER;
        UART_TX_P_USER = frame;
         UART_TX_V_USER = 1;
        #TX_PER;
         UART_TX_V_USER = 0;
        for (I = 0; I < 10; I = I + 1)
            begin
                #TX_PER;
            end
    end
endtask

task    Wait_for_Response;
    integer I;
    begin
        //Two Tx Clock Cycles for frame to reach Tx through Synchronizers.
        for (I = 0; I < 2; I = I + 1)
            begin
                #TX_PER;
            end

        //Eleven Tx Clock Cycles to send frame.
        for (I = 0; I < 11; I = I + 1)
        begin
            #TX_PER;
        end
    end
endtask

initial 
   begin 
   $dumpfile("SYS.vcd");
   $dumpvars;
   
       //Resetting the System
        RST_tb = 0;
        REF_CLK_tb = 0;
        UART_CLK_tb = 0;
		
		
        //Initial Values for Testbench's UART
        UART_TX_CLK_USER = 0;               
        prescale_USER = 8;
        parity_enable_USER= 1;
        parity_type_USER = 0;
       
        #UART_PER
        RST_tb = 1;
        #UART_PER;

        //Initial values for System UART
        DUT.U0_RegFile.regArr[2] = 8'b00_01000_01;
        DUT.U0_RegFile.regArr[3] = 8;
		
		
		//Sending Register Read Command
        //0xBB
        $display("----------Reading from Register 2 (Initial UART Configuration)----------");

        Send_Frame(RF_Read);
       
        Send_Frame(2);
		
		
		
		 Wait_for_Response();
        
        $display("TEST CASE 1: Received Correct Data.");
        if (UART_RX_OUT_P_USER == 8'b00_01000_01)
            $display("TEST CASE 1 PASSED.");
        else
            $display("TEST CASE 1 FAILED.");
			
	    

			
			//Sending Register Write Command
        //0xAA
        //Changing UART Configuration
        $display("\n----------Writing to Register 2 (Changing UART Configuration to Odd Parity)----------");
        Send_Frame(RF_Write);
        Send_Frame(10);
        Send_Frame(8'b00_01000_11);            
		
		
		$display("TEST CASE 2: Wrote Data.");
        if (DUT.U0_RegFile.regArr[10] == 8'b00_01000_11)
            $display("TEST CASE 2 PASSED.");
        else
            $display("TEST CASE 2 FAILED.");
			
	    
        //Sending ALU with Operands Command
        //0xCC
        $display("\n\n----------ALU Operation with Operands (Addition)----------");
        Send_Frame(ALU_Op);
        Send_Frame(28);
        Send_Frame(14);
        Send_Frame(ADD);
		
		
		 Wait_for_Response();

        $display("TEST CASE 8: Received Correct Result.");
        if (UART_RX_OUT_P_USER == 42)
            $display("TEST CASE 3 PASSED.");
        else
            $display("TEST CASE 3  FAILED.");
			
			
			
	    //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (Subtraction)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(SUB);
		
		
		
		 Wait_for_Response();

        $display("TEST CASE 4 : Received Correct Result.");
        if (UART_RX_OUT_P_USER == 14)
            $display("TEST CASE 5 PASSED.");
        else
            $display("TEST CASE 4  FAILED.");
			
			
			
			
		//Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (AND)----------");
        Send_Frame(ALU_Op);
        Send_Frame(8'b1111_0000);
        Send_Frame(8'b0000_1111);
        Send_Frame(AND);
		
		 Wait_for_Response();

        $display("TEST CASE 4 : Received Correct Result.");
        if (UART_RX_OUT_P_USER == 0)
            $display("TEST CASE 5 PASSED.");
        else
            $display("TEST CASE 5  FAILED.");
		
		
		
		//Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (SHIFT RIGHT)----------");
        Send_Frame(ALU_Op);
        Send_Frame(8'b0010_1010);
        Send_Frame(0);
        Send_Frame(SHR);
		
		
		
		 Wait_for_Response();

        $display("TEST CASE 34: Received Correct Result.");
        if (UART_RX_OUT_P_USER == 8'b0001_0101)
            $display("TEST CASE 6 PASSED.");
        else
            $display("TEST CASE 6 FAILED.");
			
			  $stop;
    end

	
	
	//Clocks Generation
always #H_SYS_PER       REF_CLK_tb  = ~REF_CLK_tb;
always #H_UART_PER      UART_CLK_tb = ~UART_CLK_tb; 
always #H_TX_PER        UART_TX_CLK_USER = ~UART_TX_CLK_USER; 


//Instantiation
SYS_TOP DUT (
    .REF_CLK(REF_CLK_tb),
    .UART_CLK(UART_CLK_tb),
    .RST(RST_tb),
    .RX_IN(RX_IN_tb),
    .TX_OUT(TX_OUT_tb)
);


UART_TOP USER
(
.RST(RST_tb),
.RX_IN_S(TX_OUT_tb),
.TX_OUT_S(RX_IN_tb),
.RX_CLK(UART_CLK_tb),
.TX_CLK(UART_TX_CLK_USER),
.RX_OUT_P(UART_RX_OUT_P_USER),
.RX_OUT_V(UART_RX_V_OUT_USER),
.TX_IN_P(UART_TX_P_USER),
.TX_IN_V(UART_TX_V_USER),
.TX_OUT_Busy(TX_OUT_Busy_USER),
.Prescale(prescale_USER),
.parity_enable(parity_enable_USER),
.parity_type(parity_type_USER)
);

endmodule