module DATA_SYNC
#(parameter DATA_WIDTH = 8 ,NUMB_STAGES = 2)
(
input wire CLK,
input wire REST,
input wire bus_en,
input wire [DATA_WIDTH-1:0] Unsync_bus,
output reg enable_pluse,
output reg [DATA_WIDTH-1:0]Sync_bus
);

integer N_FF;
reg [NUMB_STAGES-1:0] sync_flops;
reg Pulse_bt;
wire d_enable_pulse;



always@(posedge CLK ,negedge REST)
begin
  if(!REST)
        begin
	     Sync_bus <= 'b0 ;
		end
  else 
        begin 
		 if (d_enable_pulse)
		   begin
             Sync_bus <= Unsync_bus;
		   end
		else if(!d_enable_pulse)
		   begin
          Sync_bus  <= Sync_bus;
           end
		 end  
end


always@(posedge CLK , negedge REST)
begin 
   if (!REST)
      begin 
	    sync_flops <= 0 ;
	  end
   else 
      begin
        sync_flops[0] <= bus_en ;
		  for(N_FF = 1 ; N_FF < NUMB_STAGES ; N_FF = N_FF+1)
		    begin
			  sync_flops[N_FF] <= sync_flops[N_FF-1];
			  Pulse_bt   <= sync_flops[NUMB_STAGES-1] ;
			end
	  end
end




assign d_enable_pulse = (~Pulse_bt) & sync_flops[NUMB_STAGES-1];

always@ (posedge CLK , negedge REST)
begin 
   if (!REST)
      begin 
	     enable_pluse <= 0 ;
	  end
   else
      begin 
	     enable_pluse <= d_enable_pulse ;
	  end
end


endmodule
	  
     		