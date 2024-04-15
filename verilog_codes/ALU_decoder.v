module ALU_decoder(op5,funct3, funct7_5, ALUOp, ALUControl,load_store);
	input op5, funct7_5;
	input [2:0]funct3;
	input [1:0]ALUOp;
	output reg [3:0]ALUControl;
	output reg [2:0]load_store;
	
	wire Rtypesub;
	assign Rtypesub=funct7_5 & op5;
	
	always@(*)
	casex(ALUOp)
		2'b00: begin //load,store
					ALUControl=4'b0000; //lw,sw (addition)
					case(funct3) 
						3'b000: load_store <= 3'b001;    // lb,sb
						3'b001: load_store <= 3'b010;    // lh,sh
						3'b010: load_store <= 3'b000;    // lw,sw
						3'b100: load_store <= 3'b011;    // lbu
						3'b101: load_store <= 3'b100;    // lhu
						default: load_store <= 3'bxxx;
					endcase
				end
					
				
		2'b01: begin //branch
					ALUControl=4'b0001; //beq (subtraction)
					load_store=3'b000;
					
				end
		2'b10: begin //Itype-alu, Rtype
					load_store=3'b000;
					casex(funct3)
						3'b000: begin
									if(Rtypesub) ALUControl=4'b0001; //sub
									else ALUControl=4'b0000; //add,addi
								end
						3'b001: ALUControl=4'b0010;//sll,slli
						3'b010: ALUControl=4'b0011; //slt,slti
						3'b011: ALUControl=4'b0100;//sltu,sltiu
						3'b100: ALUControl=4'b0101;//xor,xori
						3'b101: ALUControl={3'b011, op5};//srl,sra,srli,srai
						3'b110: ALUControl=4'b1000; //or,ori
						3'b111: ALUControl=4'b1001; //and.andi
						default: ALUControl=3'bxxx; //
					endcase
				end
		2'b11: begin //auipc,lui,jal,jalr
					load_store <= 3'b0;
               ALUControl <= 4'b0;
				end
				
		default: begin
						load_store <= 3'bx; 
						ALUControl <= 4'bx;
					end

	endcase
	
endmodule
