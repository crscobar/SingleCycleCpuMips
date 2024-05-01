// Example testbench for MIPS processor

module testbench();
	logic clk, reset;
  	logic [31:0] writedata, aluout;
  	logic memwrite;

  	// instantiate device to be tested
  	top dut(clk, reset, writedata, aluout, memwrite);
  
  	// initialize test
  	initial
    	begin
      		reset <= 1; # 22; reset <= 0;
    	end

  	// generate clock to sequence tests
  	always
    	begin
     		clk <= 1; # 5; clk <= 0; # 5;
			$display("%b", dut.mips.alucontrol);
    	end

  	// check that 7 gets written to address 84
  	always@(negedge clk) begin
      	if(memwrite) begin
        	// if(aluout === 84 & writedata === 7) begin
          	// 	$display("Simulation succeeded");
          	// 	$stop;
        	// end 
			// else if (aluout !== 80) begin
          	// 	$display("Simulation failed");
          	// 	$stop;
        	// end
      	end
    end
endmodule