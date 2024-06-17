module ALU_decoder(op5,funct3, funct7_5, funct7_4, ALUOp, ALUControl,load_store);
	input op5, funct7_5, funct7_4;
	input [1:0]ALUOp;
	input [2:0]funct3;
	output reg [2:0]load_store;
	output reg [3:0]ALUControl;
	
	wire wire75, wire74;
	assign wire75=funct7_5 & op5;
	assign wire74 = funct7_4 & op5;
	
	always@(*) begin
		casex(ALUOp)
			2'b00: begin //load,store
						ALUControl=4'b0000; //lw,sw (addition)
						case(funct3) 
							3'b000: load_store <= 3'b001;    // lb,sb
							3'b001: load_store <= 3'b010;    // lh,sh
							3'b010: load_store <= 3'b000;    // lw,sw
							3'b100: load_store <= 3'b011;    // lbu
							3'b101: load_store <= 3'b100;    // lhu
							default: load_store <= 3'b000;
						endcase
					end
						
					
			2'b01: begin //branch
						ALUControl=4'b0001; // (subtraction)
						load_store=3'b000;
						
					end
			2'b10: begin //Itype-alu, Rtype
						load_store=3'b000;
						casex(funct3)
							3'b000: begin
										if(wire75) ALUControl=4'b0001; //sub
										else ALUControl=4'b0000; //add,addi
									end
							3'b001: ALUControl=4'b0010; //sll,slli
							3'b010: begin
									if (wire74)  ALUControl=4'b1101; //sh1add
									else ALUControl=4'b0011; //slt,slti
							end
							3'b011: ALUControl=4'b0100; //sltu,sltiu
							3'b100: begin
									if (wire74) ALUControl=4'b1110; //sh2add
									else if (wire75) ALUControl=4'b1100;//xorn
									else ALUControl=4'b0101; //xor,xori
							end
							3'b101: ALUControl={3'b011, funct7_5};// 0(srl,srli), 1(sra,srai)
							3'b110: begin
									if (wire74) ALUControl=4'b1111; //sh3add
									else if (wire75) ALUControl=4'b1011; //orn
									else ALUControl=4'b1000; //or,ori
							end
							3'b111: begin
									if (wire75)ALUControl=4'b1010; //andn
									else ALUControl=4'b1001; //and,andi
							end
							default: ALUControl=3'bxxx; //
						endcase
					end
			2'b11: begin //auipc,lui,jal,jalr
						load_store <= 3'b000;
						ALUControl <= 4'b0000;
					end
					
			default: begin
							load_store <= 3'bx; 
							ALUControl <= 4'bx;
						end

		endcase
	end
endmodule
