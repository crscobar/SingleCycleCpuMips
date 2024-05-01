module testbench_c();
	logic clk, reset;
  	logic [31:0] writedata, aluout;
  	logic memwrite;

  	// instantiate device to be tested
  	top dut(clk, reset, writedata, aluout, memwrite);
  
  	// initialize test
  	initial
    	begin
      		reset <= 1; #22; reset <= 0;
    	end

  	// generate clock to sequence tests
  	always
    	begin
     		clk <= 1; # 5; clk <= 0; # 5;
    	end

  	always@(negedge clk) begin
      	if(memwrite) begin
        	if(aluout === 36 & writedata === -6) begin
          		$display("Simulation succeeded");
          		$stop;
        	end 
			// else if (aluout !== 40 || aluout !== 44 || aluout !== 48 || aluout !== 52 || aluout !== 56 || aluout !== 60) begin
          	// 	$display("Simulation failed");
          	// 	$stop;
        	// end
      	end
    end
endmodule
