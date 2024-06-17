module register_file #(parameter DATA_WIDTH = 32) (
    input       clk,
    input       [4:0] A1, A2, A3,
    input       [DATA_WIDTH-1:0] WD3,
    input       WE3,
    output      [DATA_WIDTH-1:0] RD1, RD2
);

	reg [DATA_WIDTH-1:0] reg_file_arr [0:31];

	
	integer i;
	initial begin
		 for (i = 0; i < 32; i = i + 1) begin
			  reg_file_arr[i] = 0;
		 end
	end

	
	always @(posedge clk) begin
		 if (WE3) reg_file_arr[A3] <= WD3;
	end

	
	assign RD1 = ( A1 != 0 ) ? reg_file_arr[A1] : 0;
	assign RD2 = ( A2 != 0 ) ? reg_file_arr[A2] : 0;

endmodule	