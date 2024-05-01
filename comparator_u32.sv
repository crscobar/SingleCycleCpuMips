module comparator_u32 #(parameter N=32)(
		input logic unsigned [N-1:0] A, B,
		output logic lt);
	
	assign lt = (A < B);  
endmodule