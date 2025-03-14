
`include "syn_fifo.v"

module tb;
	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter PTR_WIDTH=$clog2(DEPTH);

	reg clk_i,rst_i,wr_en_i,rd_en_i;
	reg [WIDTH-1:0] wdata_i;

	wire [WIDTH-1:0] rdata_o;
	wire full_o,empty_o,wr_error_o,rd_error_o;
	integer i;

fifo dut (.*);

//clk generation
always begin
	clk_i=0;#5;
	clk_i=1;#5;
end

initial begin
	clk_i=0;rst_i=1;
	reset();
	#30;
	rst_i=0;
	write_fifo(0,DEPTH);
	read_fifo(0,DEPTH);
end


task reset();
begin
	wr_en_i=0;
	rd_en_i=0;
	wdata_i=0;
end
endtask

task write_fifo(input integer start_loc , input integer end_loc);
begin
	for (i=start_loc;i<start_loc+end_loc;i=i+1) begin
		@(posedge clk_i);
		wr_en_i=1;
		wdata_i=$random;
	end
	@(posedge clk_i);
	wr_en_i=0;
	wdata_i=0;
end
endtask

task read_fifo(input integer start_loc , input integer end_loc);
begin
	for (i=start_loc;i<start_loc+end_loc;i=i+1) begin
		@(posedge clk_i);
		rd_en_i=1;
	end
	@(posedge clk_i);
	rd_en_i=0;
end
endtask


initial #500 $finish();

endmodule
