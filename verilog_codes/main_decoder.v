module main_decoder(opcode, Branch, Jump, jalr, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);
	input [6:0] opcode;
	output Branch, MemWrite, ALUSrc, RegWrite, Jump, jalr;
	output [1:0] ResultSrc;
	output [1:0] ALUOp;
	output [2:0] ImmSrc;
	
	reg[12:0] controls;
	
	always@(*) begin
	casex(opcode)					//branch_jump_jalr_MemWrite_RegWrite_ResultSrc_ALUSrc_ImmSrc_ALUOp
		
		7'b0110111: controls = 13'b0______0____0______0_________1________11______x_____100____11;//lui(U)
		
		7'b0010111: controls = 13'b0______0____0______0_________1________11______x_____100____11;//auipc(U)
		
		7'b1101111: controls = 13'b0______1____0______0_________1________10______1_____011____11;//jal(J)
		
		7'b1100111: controls = 13'b0______0____1______0_________1________10______1_____000____11;//jalr(I)
		
		7'b1100011: controls = 13'b1______0____0______0_________0________xx______0_____010____01;//B type-branch
		
		7'b0000011: controls = 13'b0______0____0______0_________1________01______0_____000____00;//I type-load
		
		7'b0100011: controls = 13'b0______0____0______1_________0________xx______0_____001____00;//S type-store
		
		7'b0010011: controls = 13'b0______0____0______0_________1________00______0_____000____10;//I type-ALU
		
		7'b0110011: controls = 13'b0______0____0______0_________1________00______0_____xxx____10;//R type
		
	endcase
	end
	
	assign {Branch,Jump,jalr,MemWrite,RegWrite,ResultSrc,ALUSrc,ImmSrc,ALUOp}=controls;
	
endmodule