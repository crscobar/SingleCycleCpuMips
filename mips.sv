// files needed for simulation:
// mipsttest.sv   mipstop.sv, mipsmem.sv,  mips.sv,  mipsparts.sv

// single-cycle MIPS processor
module mips(
		input logic clk, reset,
    	output logic [31:0] pc,
    	input logic [31:0] instr,
    	output logic memwrite,
    	output logic [31:0] aluout, writedata,
    	input logic [31:0] readdata);

  	logic memtoreg, branch, pcsrc, zero, alusrc, regdst, regwrite, jump;
  	logic [2:0]  alucontrol;

  	controller c(instr[31:26], instr[5:0], zero, neg_pos, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);

  	datapath dp(clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump, alucontrol, zero, neg_pos, pc, instr, aluout, writedata, readdata);
endmodule

module controller(
		input logic [5:0] op, funct,
        input logic zero, neg_pos,
        output logic memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump,
        output logic [2:0] alucontrol);

  	logic [1:0] aluop;
  	logic branch, beq_check, bne_check, bne, bgt;

  	maindec md(op, memtoreg, memwrite, branch, bne, bgt, alusrc, regdst, regwrite, jump, aluop);
 	aludec ad(funct, aluop, alucontrol);
	assign beq_check = branch & zero;
	assign bne_check = bne & ~zero;
	assign bgt_check = bgt & neg_pos;
 	assign pcsrc = beq_check | bne_check | bgt_check;
endmodule

module maindec(
		input logic [5:0] op,
        output logic memtoreg, memwrite, branch, bne, bgt, alusrc, regdst, regwrite, jump,
        output logic [1:0] aluop);

  	logic [10:0] controls;

  	assign {regwrite, regdst, alusrc, branch, bne, bgt, memwrite, memtoreg, jump, aluop} = controls;

  	always_comb
    	case(op)
      		6'b000000: controls = 11'b11000000010;	// R-Type
      		6'b100011: controls = 11'b10100001000; // LW
      		6'b101011: controls = 11'b00100010000; // SW
      		6'b000100: controls = 11'b00010000001; // BEQ
      		6'b001000: controls = 11'b10100000000; // ADDI
      		6'b000010: controls = 11'b00000000100; // J
			6'b000101: controls = 11'b00001000001; // BNE
			6'b001100: controls = 11'b10100000011; // ANDI
			6'b010101: controls = 11'b00000100001; // BGT
      		default:   controls = 11'bxxxxxxxxxxx; // ???
    	endcase
endmodule

module aludec(
		input logic [5:0] funct,
        input logic [1:0] aluop,
        output logic [2:0] alucontrol);

  	always_comb
    	case(aluop)
      		2'b00: alucontrol = 3'b010; // add
      		2'b01: alucontrol = 3'b110;	// sub
			2'b11: alucontrol = 3'b000;	// andi
      	default: case(funct)          	// RTYPE
          	6'b100000: alucontrol = 3'b010; // ADD
          	6'b100010: alucontrol = 3'b110; // SUB
          	6'b100100: alucontrol = 3'b000; // AND
          	6'b100101: alucontrol = 3'b001; // OR
          	6'b101010: alucontrol = 3'b111; // SLT
			6'b101011: alucontrol = 3'b011;	// SLTU
          	default:   alucontrol = 3'bxxx; // ???
        endcase
    endcase
endmodule

module datapath(
	input logic clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump,
    input logic [2:0]  alucontrol,
    output logic zero, neg_pos,
    output logic [31:0] pc,
    input  logic [31:0] instr,
    output logic [31:0] aluout, writedata,
    input  logic [31:0] readdata);

  	logic [4:0]  writereg;
  	logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  	logic [31:0] signimm, signimmsh;
  	logic [31:0] srca, srcb;
  	logic [31:0] result;

  	// next PC logic
  	flopr #(32) pcreg(clk, reset, pcnext, pc);
  	adder pcadd1(pc, 32'b100, pcplus4);
  	sl2 immsh(signimm, signimmsh);
  	adder pcadd2(pcplus4, signimmsh, pcbranch);
  	mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  	mux2 #(32) pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);

  	// register file logic
  	regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, result, srca, writedata);
  	mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);
  	mux2 #(32) resmux(aluout, readdata, memtoreg, result);
  	signext se(instr[15:0], signimm);

  	// ALU logic
  	mux2 #(32) srcbmux(writedata, signimm, alusrc, srcb);
  	alu alu_(.A(srca), .B(srcb), .F(alucontrol), .Y(aluout), .zero(zero));
	assign neg_pos = aluout[31];
endmodule