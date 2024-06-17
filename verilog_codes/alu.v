module alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
	input [31:0] SrcA, SrcB;
	input [3:0] ALUControl;
	output reg [31:0] ALUResult;
	output Zero;	
	
	assign Zero = (ALUResult==0)? 1'b1 : 1'b0;
	
	always @(SrcA or SrcB or ALUControl) begin
	
		casex(ALUControl)
		4'b0000: ALUResult <= SrcA + SrcB; //addition-lw,sw,add,addi
		4'b0001: ALUResult <= SrcA + (~SrcB) + 1; //subtraction-beq,sub
		4'b0010: ALUResult <= (SrcA << SrcB[4:0]); //sll,slli
		4'b0011: if (SrcA[31] != SrcB[31]) ALUResult <= SrcA[31]? 32'd0: 32'd1; //slt,slti
					else ALUResult <= (SrcA<SrcB)? 32'd1 : 32'd0; 
		4'b0100: ALUResult <= (SrcA<SrcB)? 32'b1 : 32'b0; //sltu, sltiu
		4'b0101: ALUResult <= SrcA ^ SrcB; //xor,xori
		4'b0110: ALUResult <= (SrcA >> SrcB[4:0]);//srl, srli
		4'b0111: ALUResult <=  (SrcA >>> SrcB[4:0]);//sra, srai
		4'b1000: ALUResult <= SrcA | SrcB; //or, ori
		4'b1001: ALUResult <= SrcA & SrcB; //and,andi
		//b-extention
		
		4'b1010: ALUResult <= ~(SrcA & SrcB); //andn
		4'b1011: ALUResult <= ~(SrcA | SrcB); //ornn
		4'b1100: ALUResult <= ~(SrcA ^ SrcB); //xnor
		4'b1101: ALUResult <= (SrcA<<1) + SrcB;//sh1add
		4'b1110: ALUResult <= (SrcA<<2) + SrcB;//sh2add
		4'b1111: ALUResult <= (SrcA<<3) + SrcB;//sh3add
		

		
		default: ALUResult <= 32'd0;
		endcase
	end
	
endmodule