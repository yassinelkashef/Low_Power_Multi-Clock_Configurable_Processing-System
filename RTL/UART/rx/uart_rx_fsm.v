module fsm_rx(
input wire rx_in,
input wire clk,
input wire rest,
input wire [3:0]bit_cnt,
input wire [4:0]edge_cnt,/////
input wire par_en,
input wire par_typ,
input wire par_err,
input wire strt_glitch,
input wire stp_err,
output reg dat_samp_en,
output reg enable,
output reg par_chk_en,
output reg strt_chk_en,
output reg stp_chk_en,
output reg deslz_en,
output reg d_valid
);


localparam [2:0]    idle = 3'b000,
                   start = 3'b001,
				    data = 3'b011,
				 par_bit = 3'b010,
				    stop = 3'b110,
                   check = 3'b111;
					
reg[2:0] current_state,next_state;

//state transation
always@(posedge clk , negedge rest)
begin
 if(!rest)
    current_state <= idle ;
 else 
    current_state <= next_state ;
end

//next state logic
always@(*)					
begin 
    case(current_state)
	  idle : begin 
	             if (rx_in==1'b0)
	               next_state = start ;
				 else 
				 next_state= idle;
			 end
	 start : begin  
	            if(strt_glitch&&bit_cnt==4'b0&&edge_cnt==5'b111)
				   next_state = idle ;
                else if(!strt_glitch&&bit_cnt==4'b0&&edge_cnt == 5'b111)  
			       next_state = data ;
				else
				   next_state = start ;
			 end	   
	 data : begin 
	           
                if (par_en&&bit_cnt==4'b1000&&edge_cnt==5'b111)
	              next_state = par_bit ;
            	else if (!par_en&&bit_cnt==4'b1000&&edge_cnt==5'b111)
                  next_state = stop ;
				else
                  next_state = data ;
            end				
	 par_bit  : begin 
	            if (bit_cnt==4'b1001 && edge_cnt==5'b111)
				next_state = stop ;
				else
				next_state = par_bit;
                end	
     stop     : begin 
	            if (bit_cnt == 4'b1010&&edge_cnt==5'b111)
				next_state = check;
	            else
                next_state = stop ;
                end	
     check    : begin
	            next_state = idle ;
                end
	 default   : begin
			 next_state = idle ; 
                 end	
endcase
end
				
	 
//output logic		  		
always@(*)
begin
                enable = 1'b0;
                par_chk_en= 1'b0;
                strt_chk_en= 1'b0;
                stp_chk_en= 1'b0;
                deslz_en= 1'b0;
				dat_samp_en = 1'b0 ;
                d_valid=1'b0;
     case(current_state)
	   idle : begin
	   if (rx_in==1'b0)
	           begin
	            enable = 1'b1;
                par_chk_en= 1'b0;
                strt_chk_en= 1'b1;
                stp_chk_en= 1'b0;
                deslz_en= 1'b0;
				dat_samp_en = 1'b1 ;
                d_valid=1'b0;
			  end
	 else 
	          begin
			   enable = 1'b0;
                par_chk_en= 1'b0;
                strt_chk_en= 1'b0;
                stp_chk_en= 1'b0;
                deslz_en= 1'b0;
				dat_samp_en = 1'b0 ;
                d_valid=1'b0;
				end
				end
			  
        start : begin
		         enable = 1'b1 ;
				 strt_chk_en=1'b1;
				 par_chk_en= 1'b0;
		         stp_chk_en= 1'b0;
	             deslz_en= 1'b0; 
                 dat_samp_en = 1'b1 ;				 
				 d_valid=1'b0;
				 end
	     data :  begin
		         enable = 1'b1 ;
				 strt_chk_en = 1'b0 ;
				 par_chk_en = 1'b0 ;
                 stp_chk_en = 1'b0 ;
                 dat_samp_en = 1'b1 ;
                 if(edge_cnt==5'b111)
                 deslz_en = 1'b1 ;
               else 
                 deslz_en = 1'b0;
                 d_valid = 1'b0 ;
				 end
		par_bit: begin 
                  enable = 1'b1 ;
                  strt_chk_en = 1'b0 ;
                  par_chk_en =1'b1 ;
                  stp_chk_en = 1'b0;
                  dat_samp_en = 1'b1 ;
                  deslz_en = 1'b0 ;
                  d_valid = 1'b0 ;
                 end
        stop   : begin 
		           enable = 1'b1 ;
				   strt_chk_en = 1'b0 ;
				   par_chk_en = 1'b0 ;
				   stp_chk_en = 1'b1 ;
				   dat_samp_en = 1'b1 ;
				   deslz_en = 1'b0 ;
				   d_valid = 1'b0; 
				   end
				   
				   
		check  :  begin
		           enable = 1'b0 ;
				   strt_chk_en = 1'b0 ;
				   par_chk_en = 1'b0 ;
				   stp_chk_en = 1'b0 ;
				   dat_samp_en = 1'b0 ;
				   deslz_en = 1'b0 ;
				   d_valid = 1'b1; 
				   end
		default :  begin
		        enable = 1'b0;
                par_chk_en= 1'b0;
                strt_chk_en= 1'b0;
                stp_chk_en= 1'b0;
                deslz_en= 1'b0;
				dat_samp_en = 1'b0 ;
                d_valid=1'b0;
				end
		
endcase
end

				   
endmodule				   
				   
				   
			  







