module take_branch_logic(Branch, SrcA31, SrcB31, funct3, zero, ALUR31, takebranch);
	input Branch, SrcA31, SrcB31, zero, ALUR31;
	input [2:0]funct3;
	output reg takebranch;

	always@(*) begin 
		takebranch = 0;
		if (Branch) begin
			casex(funct3)
				
				3'b000: takebranch= zero; //beq
				
				3'b001: takebranch= ~zero; //bne
						
				3'b100: takebranch= (SrcA31==SrcB31)? ALUR31 : ~ALUR31; //blt
				
				3'b101: takebranch= (SrcA31==SrcB31)? ~ALUR31 : ALUR31; //bge

				3'b110: takebranch= ALUR31; //bltu
				
				3'b111: takebranch= ~ALUR31; //bgeu
				
				default: takebranch=0;
			endcase
		end
		
		else takebranch = 0;
		
	end
endmodule
