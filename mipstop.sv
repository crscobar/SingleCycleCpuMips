//------------------------------------------------
// Top level system including MIPS and memories
//------------------------------------------------

module top(
		input logic clk, reset, 
        output logic [31:0] writedata, aluout, 
        output logic memwrite);

  	logic [31:0] pc, instr, readdata;
  
  	// instantiate processor and memories

 	mips mips(clk, reset, pc, instr, memwrite, aluout, writedata, readdata);

  	imem imem(pc[7:2], instr);

  	dmem dmem(clk, memwrite, aluout, writedata, readdata);

endmodule