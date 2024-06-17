module main_decoder(opcode, Branch, Jump, jalr, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);
	input [6:0] opcode;
	output Branch, MemWrite, ALUSrc, RegWrite, Jump, jalr;
	output [1:0] ResultSrc;
	output [1:0] ALUOp;
	output [2:0] ImmSrc;
	
	reg[12:0] controls;
	
	assign {Branch,Jump,jalr,MemWrite,RegWrite,ResultSrc,ALUSrc,ImmSrc,ALUOp}=controls;
	
	always@(*) begin
	casex(opcode)						//branch_jump_jalr_MemWrite_RegWrite_ResultSrc_ALUSrc_ImmSrc_ALUOp
		
		7'b0110111: controls = 13'b_____0______0____0______0_________1_______11______x_____100____11;//U type: lui
		
		7'b0010111: controls = 13'b_____0______0____0______0_________1_______11______x_____100____11;//U type: auipc
		
		7'b1101111: controls = 13'b_____0______1____0______0_________1_______10______x_____011____11;//J type: jal
		
		7'b1100111: controls = 13'b_____0______0____1______0_________1_______10______1_____000____11;//I type: jalr
		
		7'b1100011: controls = 13'b_____1______0____0______0_________0_______xx______0_____010____01;//B type(branch): beq, bne, blt, bge, bltu, bgeu
		
		7'b0000011: controls = 13'b_____0______0____0______0_________1_______01______1_____000____00;//I type(load): lb, lh, lw, lbu, lhu
		
		7'b0100011: controls = 13'b_____0______0____0______1_________0_______xx______1_____001____00;//S type(store): sb, sh, sw
		
		7'b0010011: controls = 13'b_____0______0____0______0_________1_______00______1_____000____10;//I type(ALU): addi, slli, slti, sltiu, srli, srai, andi, ori, xori
		
		7'b0110011: controls = 13'b_____0______0____0______0_________1_______00______0_____xxx____10;//R type: add, sub, sll, slt, sltu, srl, sra, and, or, xor
		
		default:    controls = 13'b_____x______x____x______x_________x_______xx______x_____xxx____xx;//???
		
	endcase
	end
	
	
endmodule