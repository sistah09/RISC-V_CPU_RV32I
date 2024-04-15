module PCSrc_sel(takebranch, branch, jump, jalr, PCSrc);
	input takebranch, branch, jump, jalr;
	output reg [2:0] PCSrc;
	
	wire andgate;
	assign andgate= takebranch & branch;
	
	always@(*)
		case({andgate,jump,jalr})
			
			3'b000: PCSrc= 2'b00; //PC+4
			3'b100: PCSrc= 2'b01; //PCtgt
			3'b010: PCSrc= 2'b01; //PCtgt
			3'b001: PCSrc= 2'b10; //jalr
			default:PCSrc= 2'b00;
		endcase
endmodule
