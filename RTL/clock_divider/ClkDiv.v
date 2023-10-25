module clock_divider 
#( parameter ratio_width = 8)
(
input wire clk,
input wire rest,
input wire [ratio_width-1:0] divided_ratio,
input wire i_clk_en,
output wire div_clk_out
);


reg toggle_flag;
reg  div_clk;
reg [ratio_width-2:0] counter;
wire [ratio_width-2:0] first_toggle;
wire [ratio_width-2:0] second_toggle;


assign first_toggle = (divided_ratio >> 1)-1;    
assign second_toggle =  (divided_ratio >> 1) ;
assign clk_en = i_clk_en & |divided_ratio & ~(divided_ratio == 1'b1) ; 
assign div_clk_out = clk_en ? div_clk : clk;


always @(posedge clk , negedge rest)
begin
    if(!rest)
        begin
          counter <= 0;
          div_clk <= 0;
          toggle_flag <=0;
		 end
	else if (clk_en)
	   begin
	     if ( divided_ratio[0]==0 && counter==first_toggle)
		    begin
		       counter <= 0;
		       div_clk <= ~div_clk;
		    end
    
	      else if ((divided_ratio[0]==1 &&counter == first_toggle && toggle_flag == 0)||(divided_ratio[0]==1&&counter == second_toggle && toggle_flag ==1))  
		       begin                                                                                                
			    counter <= 0;
				div_clk <= ~ div_clk;
				toggle_flag <= ~ toggle_flag;
		    end
    else 
         counter <= counter + 1 ;	
            
		end   
end
endmodule



