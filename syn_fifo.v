
module fifo(clk_i,rst_i,wdata_i,rdata_o,wr_en_i,rd_en_i,full_o,empty_o,wr_error_o,rd_error_o);
parameter DEPTH=16;
parameter WIDTH=8;
parameter PRT_WIDTH=$clog2(DEPTH);

input clk_i,rst_i,wr_en_i,rd_en_i;
input [WIDTH-1:0] wdata_i;

output reg [WIDTH-1:0] rdata_o;
output reg full_o,empty_o,wr_error_o,rd_error_o;

//internal reg data types
reg [PRT_WIDTH-1:0] wr_ptr,rd_ptr;
reg wr_toggle_f,rd_toggle_f;

// declare FIFO 
reg [WIDTH-1:0] buffer [DEPTH-1:0] ;
integer i;


// synchronous fifo

always @(posedge clk_i) begin
		if (rst_i) begin
			rdata_o=0;
			full_o=0;
			empty_o=1;
			wr_error_o=0;
			rd_error_o=0;
			wr_ptr=0;
			rd_ptr=0;
			wr_toggle_f=0;
			rd_toggle_f=0;
			for (i=0;i<DEPTH;i=i+1) buffer[i]=0;
		end
		else begin
				wr_error_o=0;
				rd_error_o=0;
				//write to the FIFO
				if (wr_en_i==1) begin
					if (full_o==1) begin
							wr_error_o=1;
					end
					else begin
							buffer[wr_ptr]=wdata_i;
							if (wr_ptr == DEPTH-1) wr_toggle_f=~wr_toggle_f;
							wr_ptr=wr_ptr+1;
					end
				end
				//read from the FIFO
				if (rd_en_i==1) begin
					if (empty_o==1) begin
						rd_error_o=1;
					end
					else begin
							rdata_o=buffer[rd_ptr];
							if (rd_ptr==DEPTH-1) rd_toggle_f=~rd_toggle_f;
							rd_ptr=rd_ptr+1;
					end
				end
	end
end


always @(*) begin
	full_o=0;
	empty_o=0;
	if (wr_ptr == rd_ptr && wr_toggle_f != rd_toggle_f) full_o=1;
	else full_o=0;
	if (wr_ptr == rd_ptr && wr_toggle_f == rd_toggle_f) empty_o=1;
	else empty_o=0;
end

endmodule
