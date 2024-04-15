
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData
);

// Uncomment the following lines if you are going to use module instantiation method

 wire ALUSrc, RegWrite, Jump, Zero;
 wire [1:0] ResultSrc, ImmSrc, PCSrc;
 wire [2:0] ALUControl, load_store;
 
  wire Op5;
  assign Op5=Instr[5];
  
 wire SrcA31, SrcB31, ALUR31;


 controller c (Instr[6:0], Instr[14:12], Instr[30], Zero,
					SrcA31, SrcB31, ALUR31,	ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite,  ImmSrc,  ALUControl, load_store);

 datapath dp (clk, reset, PCSrc, ResultSrc, ALUSrc, Op5, RegWrite, ImmSrc,  ALUControl, load_store, Instr, ReadData,
              Zero, PC, Mem_WrAddr, Mem_WrData);

endmodule

