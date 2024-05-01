
module alu #(parameter N=32)(
		input logic [N-1:0] A, B, 
		input logic [2:0] F, 
		output logic [N-1:0] Y, 
		output logic zero);
	
	logic [N-1:0] X, X_ext, approximate, X11_output, sltu;
	wire [N-1:0] newB, AB, A_or_B;
    logic lt;
	
	mux2_1 newB_mux(B, ~B, F[2], newB);
	and_32 allands(A, newB, AB);
	or_32 allors(A, newB, A_or_B);
	add_sub_slt thingy(A, newB, F[2], X, OF);
	assign X_ext = {31'h00000000, X[N-1]}; 
	comparator_u32 unsigned_comp(A, B, lt);
    assign sltu = {31'h00000000, lt};
	mux2_1 slt_or_sltu(sltu, X_ext, F[2], X11_output);
	mux4_1 finalOut(AB, A_or_B, X, X11_output, F[1:0], Y);
	wide_or zeroz(Y, zero);
endmodule

module add_sub_slt #(parameter N=32)(
		input logic [N-1:0] A, B, 
		input logic F2, 
		output logic [N-1:0] Y,
		output logic OF);
		
	logic [N-1:0]temp;
	wire Cout, eq, gt, slt;
	adder_32_b operation(A, B, F2, Y, Cout, OF);
	comparator_32_b slt_finder(A, B, eq, slt, gt);
	
endmodule

module adder_32_b #(parameter N=32)
		(input logic [N-1:0] A, B, 
		input logic Cin,
		output logic [N-1:0] S, 
		output logic Cout, OF);
	logic [31:0] w;
	
	one_b_FA m0(A[0], B[0], Cin, S[0], w[0]);
	
	genvar i;
    generate
        for (i = 1; i < N; i = i + 1)
            begin : FA_chain
                one_b_FA mX(A[i], B[i], w[i-1], S[i], w[i]);
            end  
    endgenerate

	assign OF = w[30] ^ w[31];
endmodule

module and_32 #(parameter N=32)(
       input logic [N-1:0] A, B,
       output logic [N-1:0] Y);

    assign Y = (A & B);
endmodule

module apm #(parameter N=32)(
		input logic [N-1:0] A, B, 
		output logic [N-1:0] Y);
		
    logic [(N/2):0] map_Y;
    logic [1:0] two_s0, two_s1, two_s2;
    logic [2:0] three_s0;
    logic [3:0] four_s0;
    wire [5:0] S; 
    wire [10:0] Cout;
    logic const_zero;

    assign const_zero = 0;
    
    genvar i;
    generate
        for (i = 0; i < (N/2) + 1; i = i + 1)
            begin : map_chain
                map chain(A[i+15:i], B, map_Y[i]);
            end

        for (i = 0; i < 5; i = i + 1)
            begin : adder_chain
                one_b_FA chain(map_Y[3*i], map_Y[3*i+1], map_Y[3*i+2], S[i], Cout[i]);
            end   
    endgenerate
    one_b_FA one5(map_Y[15], map_Y[16], const_zero, S[5], Cout[5]);

    two_b_FA two0({Cout[0], S[0]}, {Cout[1], S[1]}, const_zero, two_s0, Cout[6]);
    two_b_FA two1({Cout[2], S[2]}, {Cout[3], S[3]}, const_zero, two_s1, Cout[7]);
    two_b_FA two2({Cout[4], S[4]}, {Cout[5], S[5]}, const_zero, two_s2, Cout[8]);

    three_b_FA three0({Cout[6], two_s0}, {Cout[7], two_s1}, const_zero, three_s0, Cout[9]);

    four_b_FA four0({Cout[9], three_s0}, {const_zero, Cout[8], two_s2}, const_zero, four_s0, Cout[10]);

    assign Y = {map_Y[16:0], 10'b0000000000, Cout[10], four_s0};
endmodule

module comparator_32_b #(parameter N=32)(
		input logic [N-1:0] A, B,
		output logic eq, lt, gt);
	
	assign eq = (A == B); 
	assign lt = (A < B); 
	assign gt = (A > B); 
endmodule

module comparator_u32 #(parameter N=32)(    // for SLTU
		input logic unsigned [N-1:0] A, B,
		output logic eq, lt, gt);
	
	assign eq = (A == B); 
	assign lt = (A < B); 
	assign gt = (A > B); 
endmodule

module four_b_FA #(parameter N=4)(
		input logic [N-1:0] A, B,
        input logic Cin,
		output logic [N-1:0] S, 
        output logic Cout);
	logic [N:0] w_Carry;

    assign w_Carry[0] = Cin;
	    
    genvar i;
    generate
        for (i = 0; i < N; i=i+1)
            begin : adderChain
                one_b_FA chain(A[i], B[i], w_Carry[i], S[i], w_Carry[i+1]);
            end
    endgenerate

    assign Cout = w_Carry[N];
endmodule

module map #(parameter N=32)(
		input logic [(N/2)-1:0] A,
        input logic [N-1:0] B,
		output logic Y);
		
    logic [(N/2)-1:0] xnor_out, mux_out, B_pattern, B_rule;
    wire const_one = 1;

    assign B_pattern = {B[((N/2)-1):0]};
    assign B_rule = {B[N-1:(N/2)]};

    genvar i;
    generate
        for (i = 0; i < (N/2); i = i + 1)
            begin : xnor_chain
                assign xnor_out[i] = ~(A[i] ^ B_pattern[i]);
                mux2_1_1b dontCare(xnor_out[i], const_one, B_rule[i], mux_out[i]);
            end
    endgenerate

    assign Y = (&mux_out);
endmodule

module mux2_1 #(parameter N=32)
		(input logic [N-1:0] a0, a1, 
		input logic s,
        output [N-1:0] Y);
    assign Y = s ? a1 : a0;
endmodule

module mux2_1_1b #(parameter N=32)
		(input logic a0, a1, 
		input logic s,
        output Y);
    assign Y = s ? a1 : a0;
endmodule

module mux4_1 #(parameter N=32)
		(input logic [N-1:0] A, B, C, D,
		input logic [1:0] S,
		output logic [N-1:0] Y);
	
	always_comb
		begin
			case(S)
				2'b00: Y = A;
				2'b01: Y = B;
				2'b10: Y = C;
				2'b11: Y = D;
			endcase
		end
endmodule

module one_b_FA(
		input logic A, B, Cin,
		output logic S, Cout);
	logic xor_ab, cab, and_ab;
	assign xor_ab = A ^ B;
	assign cab = Cin & xor_ab;
	assign and_ab = A & B;
	assign S = xor_ab ^ Cin;
	assign Cout = cab ^ and_ab;
endmodule

module or_32 #(parameter N=32)(
       input logic [N-1:0] A, B,
       output logic [N-1:0] Y);

    assign Y = (A | B);
endmodule

module or_bitwise #(parameter N = 32)
		(input logic [N-1:0] A, B,
		output logic [N-1:0] Y,
		output logic Z);
	assign Y = A | B;
	assign Z = ~(|Y);
endmodule

module three_b_FA #(parameter N=3)(
		input logic [N-1:0] A, B,
        input logic Cin,
		output logic [N-1:0] S, 
        output logic Cout);
	logic [N:0] w_Carry;

    assign w_Carry[0] = Cin;
	    
    genvar i;
    generate
        for (i = 0; i < N; i=i+1)
            begin : adderChain
                one_b_FA chain(A[i], B[i], w_Carry[i], S[i], w_Carry[i+1]);
            end
    endgenerate

    assign Cout = w_Carry[N];
endmodule

module two_b_FA #(parameter N=2)(
		input logic [N-1:0] A, B, 
        input logic Cin,
		output logic [N-1:0] S, 
        output logic Cout);
    
    logic [N:0] w_Carry;

    assign w_Carry[0] = Cin;
	    
    genvar i;
    generate
        for (i = 0; i < N; i=i+1)
            begin : adderChain
                one_b_FA chain(A[i], B[i], w_Carry[i], S[i], w_Carry[i+1]);
            end
    endgenerate

    assign Cout = w_Carry[N];
endmodule

module wide_or #(parameter N=32)(
       input logic [N-1:0] X,
       output logic Y);

    assign Y = ~(|X);
endmodule