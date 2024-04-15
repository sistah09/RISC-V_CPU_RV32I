module load_extend(
	input [31:0] RD,
	input [1:0] LSB_Bits,
	input [2:0] load,
	output reg [31:0] Result
);

	reg [31:0] temp, temp2;
	
	always @(*) begin
		//temp <= 32'hff << ({LSB_Bits,3'b0});
		//temp2 <= 32'hffff << ({LSB_Bits,3'b0});
		
		//little endian
		temp <= (RD & (32'hff << ({LSB_Bits,3'b0}))) >> ({LSB_Bits,3'b0});
		temp2 <= (RD & (32'hffff << ({LSB_Bits,3'b0}))) >> ({LSB_Bits,3'b0});

		//big endian
		//temp <= (RD & (32'hff << ({~LSB_Bits,3'b0}))) >> ({~LSB_Bits,3'b0});
		//temp2 <= (RD & (32'hffff << ({~LSB_Bits,3'b0}))) >> ({~LSB_Bits,3'b0});
		
		case(load)
			3'b001: Result <= temp[7]  ?  {24'hffffff,temp[7:0]} : {24'h0,temp[7:0]};	//lb
			//3'b001: Result <= temp[31]  ?  {24'hffffff,temp[31:24]} : {24'h0,temp[31:24]};	//lb
			3'b010: Result <= temp2[15] ? {16'hffff,temp2[15:0]} : {16'h0,temp2[15:0]}; //lh
			//3'b010 :	Result <= {{16{RD[7]}},RD[15:0]};
			3'b011: Result <= {24'h0,temp[7:0]};	//lbu
			//3'b011 :	Result <= {24'b0,RD[7:0]};
			3'b100: Result <= {16'h0,temp2[15:0]};	//lhu
			//3'b100 :	Result <= {16'b0,RD[15:0]};
			default: Result <= RD;	//lw
		endcase
	end

endmodule
