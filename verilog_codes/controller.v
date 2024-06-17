module controller(opcode, funct3, funct7_5, funct7_4,
				Zero, SrcA31, SrcB31, ALUR31,
				ResultSrc, MemWrite, PCSrc,
				ALUSrc, RegWrite, ImmSrc, 
				ALUControl, load_store);
	
	input funct7_5, funct7_4;
	input Zero;
	input [2:0]funct3;
	input [6:0]opcode;
	input SrcA31, SrcB31, ALUR31;
	
	output MemWrite, ALUSrc, RegWrite;
	output [1:0] PCSrc;
	output [2:0] ImmSrc; 
	output [1:0] ResultSrc;
	output [3:0] ALUControl;
	output [2:0] load_store;
	
	wire Jump, Branch, Jalr, takebranch;
	wire [1:0]ALUOp;
					  
main_decoder md1(opcode, Branch, Jump, Jalr, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);
ALU_decoder ad1(opcode[5], funct3, funct7_5, funct7_4, ALUOp, ALUControl, load_store);
take_branch_logic tb1(Branch, SrcA31, SrcB31, funct3, Zero, ALUR31, takebranch);
PCSrc_sel ps1(takebranch, Branch, Jump, Jalr, PCSrc);

endmodule