`include "common.v"
module memory(clk,rst,w_r_i,rdata_o,wdata_i,valid_i,ready_o,addr_i);
//Parameters
//parameter DEPTH=16;
//parameter WIDTH=16;
parameter ADDR_WIDTH=$clog2(`DEPTH);
//Inout Ports
input clk,rst,w_r_i,valid_i;
input [ADDR_WIDTH-1:0] addr_i;
input [`WIDTH-1:0] wdata_i;
output reg [`WIDTH-1:0] rdata_o;
output reg ready_o;

reg [`WIDTH-1:0] mem [`DEPTH-1:0];
integer i;
always@(posedge clk)begin
	if(rst==1)begin
		ready_o=0;
		rdata_o=0;
		for(i=0;i<`DEPTH;i=i+1)begin
			mem[i]=0;
		end
end
else begin
	if(valid_i==1)begin
		ready_o=1;
	if(w_r_i==1)begin
		mem[addr_i]=wdata_i;
	end
	else begin
		rdata_o=mem[addr_i];
	end
end
else ready_o=0;
end
end
endmodule
