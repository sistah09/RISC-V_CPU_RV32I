module datapath(
 input clk, reset,
 input [1:0] PCSrc,
 input [1:0] ResultSrc,
 input ALUSrc, op5,
 input RegWrite,
 input [2:0] ImmSrc,
 input [3:0] ALUControl,
 input [2:0] load_store,
 input [31:0] Instr,
 input [31:0] ReadData,
 
 output Zero,
 output [31:0] PC,
 output [31:0] Mem_WrAddr, Mem_WrData,
 output SrcA31, SrcB31, ALUR31
 );
 
 wire [31:0] PCNext, PCPlus4, PCTarget;
 wire [31:0] ImmExt;
 wire [31:0] SrcA, SrcB;
 wire [31:0] ALUResult;
 wire [31:0] Result;
 wire [31:0] ReadData_ext;
 wire [31:0] WriteData;
 wire [31:0] luiapc;
 
 assign SrcA31 = SrcA[31];
 assign SrcB31 = SrcB[31];
 assign ALUR31 = ALUResult[31]; 
 assign Mem_WrAddr = ALUResult;
 
 
 
 //pc_mux
 mux4 #(32) pcmux(PCPlus4, PCTarget, ALUResult, 32'dx, PCSrc, PCNext);
 
 // next PC logic
 flopr #(32) pcreg(clk, reset, PCNext, PC); //pcnext_ff
 adder pcadd4(PC, 32'd4, PCPlus4);
 adder pcaddbranch(PC, ImmExt, PCTarget);
 
 // register file logic
 register_file rf(clk, Instr[19:15], Instr[24:20], Instr[11:7], Result, RegWrite, SrcA, WriteData);
 
 //sign extender
 extend ext(Instr[31:7], ImmSrc, ImmExt);
 
 // ALU logic
 mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
 alu alu1(SrcA, SrcB, ALUControl, ALUResult, Zero);
 
 //store_extend
 store_extend str_ext(WriteData, load_store[1:0], Mem_WrData);
 
 //load_extend
 load_extend ld_ext(ReadData, load_store, ReadData_ext);
 
  //result_mux
 mux4 #(32) resultmux(ALUResult, ReadData_ext, PCPlus4, luiapc, ResultSrc, Result);
 
 //luipc_mux
 mux2 #(32) luipc_mux(PCTarget, ImmExt, op5, luiapc);
 
endmodule