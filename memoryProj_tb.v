`include "memoryProj.v"
`include "common.v"
module top;
//  Parameters
//	parameter DEPTH=16;
//	parameter WIDTH=16;
	parameter ADDR_WIDTH=$clog2(`DEPTH);

//InOut Ports
	reg clk,rst,w_r_i,valid_i;
	reg [`WIDTH-1:0]wdata_i;
	reg [ADDR_WIDTH-1:0]addr_i;
	wire [`WIDTH-1:0]rdata_o;

    integer i;
	reg [25*8:0] testcase;

memory  dut(.clk(clk),
											.rst(rst),
											.w_r_i(w_r_i),
											.wdata_i(wdata_i),
											.addr_i(addr_i),
											.rdata_o(rdata_o),
											.valid_i(valid_i),
											.ready_o(ready_o));

initial begin
clk=0;
forever #5 clk=~clk;
end

task reset_mem();
	begin
		rst=1;
		w_r_i=0;
		wdata_i=0;
		valid_i=0;
		addr_i=0;
		repeat(2)@(posedge clk);
		rst=0;
	end
endtask

task write_mem(input integer start_loc,input integer end_loc);
	begin
		for(i=start_loc;i<end_loc;i=i+1)begin
			@(posedge clk)
			valid_i=1;
			wait(ready_o==1);
			w_r_i=1;
			addr_i=i;
			wdata_i=$random;
			$display("Address:%0d || Write Data:%0h",addr_i,wdata_i);			
		end
 			@(posedge clk)
			valid_i=0;
			w_r_i=0;
			addr_i=0;
			wdata_i=0;
	end
endtask

task read_mem(input integer start_loc,input integer end_loc);
	begin
		for(i=start_loc;i<end_loc;i=i+1)begin
			@(posedge clk);
			valid_i=1;
			wait(ready_o==1);
			w_r_i=0;
			addr_i=i;
			$display("Address:%0d || Read Data:%0h",addr_i,rdata_o);						
		end
		 	@(posedge clk)
			valid_i=0;
			w_r_i=0;
			addr_i=0;
	end
endtask

task mem_bd_wr();
	begin
		$readmemh("data.h",dut.mem);
	end
endtask

task mem_bd_rd();
	begin
		$writememb("output.bin",dut.mem);
	end
endtask

initial begin
	reset_mem();
	#30;
	mem_bd_wr(); 
	testcase="test_bd_rd_fr_wr";
	$display("---------------------------------------");
	$display("--------->Test Case:%0s---------",testcase);
	$display("---------------------------------------");
	case(testcase)
    "test_5r_5w":begin
		write_mem(0,5);
		read_mem(0,5);
	end
	"test_5r":begin
		read_mem(0,5);
	end
	"test_5w":begin
		write_mem(0,5);
	end
	"test_r_w":begin
		write_mem(0,`DEPTH);
		read_mem(0,`DEPTH);
	end
	"test_hr_hw":begin
		write_mem(0,`DEPTH/2);
		read_mem(0,`DEPTH/2);
	end
	"test_3/4":begin
		write_mem(0,3*(`DEPTH/4));
		read_mem(0,3*(`DEPTH/4));
	end
		"test_bd_wr":begin
	 	mem_bd_wr();	
	end
	    "test_bd_rd":begin
		mem_bd_rd();
	end
	    "test_bd_rd_fr_wr":begin
		mem_bd_rd();
		write_mem(0,`DEPTH);
	end
	    "test_bd_wr_fr_rd":begin
		mem_bd_wr();
		read_mem(0,`DEPTH);
	end
endcase
	#200;
	$finish;
end
endmodule
