module testbench_alu #(parameter N=32)();
	logic [N-1:0] A, B, Y;
	logic [2:0] F;
	logic zero, OF;

	alu dut(A, B, F, Y, zero, OF);
	
	initial begin
        $display("running regular testbench...");
        // adds
		A = 32'h00000000;	B = 32'h00000000;	F = 3'd2;	#10;	// 0, 1
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-0 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end
		A = 32'h00000000;	B = 32'hFFFFFFFF;	F = 3'd2;	#10;
        if((Y !== 32'hFFFFFFFF) || (zero != 0)) begin
            $display("TC-1 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000001;	B = 32'hFFFFFFFF;	F = 3'd2;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-2 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end
		A = 32'h000000FF;	B = 32'h00000001;	F = 3'd2;	#10;
        if((Y !== 32'h00000100) || (zero != 0)) begin
            $display("TC-3 failed.");
            $display("Expected: Y = 00000100, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end

		// sub
		A = 32'h00000000;	B = 32'h00000000;	F = 3'd6;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-4 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000000;	B = 32'hFFFFFFFF;	F = 3'd6;	#10;
        if((Y !== 32'h00000001) || (zero != 0)) begin
            $display("TC-5 failed.");
            $display("Expected: Y = 00000001, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000001;	B = 32'h00000001;	F = 3'd6;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-6 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000100;	B = 32'h00000010;	F = 3'd6;	#10;
        if((Y !== 32'h000000F0) || (zero != 0)) begin
            $display("TC-7 failed.");
            $display("Expected: Y = 000000F0, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;

		// slt
		A = 32'h00000000;	B = 32'h00000000;	F = 3'd7;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-8 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000000;	B = 32'h00000001;	F = 3'd7;	#10;
        if((Y !== 32'h00000001) || (zero != 0)) begin
            $display("TC-9 failed.");
            $display("Expected: Y = 00000001, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000000;	B = 32'hFFFFFFFF;	F = 3'd7;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-10 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000001;	B = 32'h00000000;	F = 3'd7;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-11 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'hFFFFFFFF;	B = 32'h00000000;	F = 3'd7;	#10;
        if((Y !== 32'h00000001) || (zero != 0)) begin
            $display("TC-12 failed.");
            $display("Expected: Y = 00000001, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;

		// AND
		A = 32'hFFFFFFFF;	B = 32'hFFFFFFFF;	F = 3'd0;	#10;
        if((Y !== 32'hFFFFFFFF) || (zero != 0)) begin
            $display("TC-13 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'hFFFFFFFF;	B = 32'h12345678;	F = 3'd0;	#10;
        if((Y !== 32'h12345678) || (zero != 0)) begin
            $display("TC-14 failed.");
            $display("Expected: Y = 12345678, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
        // AND (~B)
		A = 32'hFFFFFFFF;	B = 32'h00000001;	F = 3'd4;	#10;
        if((Y !== 32'hFFFFFFFE) || (zero != 0)) begin
            $display("TC-15 failed.");
            $display("Expected: Y = FFFFFFFE, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h0ECE4690;	B = 32'h0ECE4690;	F = 3'd4;	#10;
        if((Y !== 32'h00000000) || (zero != 1)) begin
            $display("TC-16 failed.");
            $display("Expected: Y = 00000000, zero = 1");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;

		// OR
		A = 32'hFFFFFFFF;	B = 32'hFFFFFFFF;	F = 3'd1;	#10;
        if((Y !== 32'hFFFFFFFF) || (zero != 0)) begin
            $display("TC-17 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h12345678;	B = 32'h87654321;	F = 3'd1;	#10;
        if((Y !== 32'h97755779) || (zero != 0)) begin
            $display("TC-18 failed.");
            $display("Expected: Y = 97755779, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
        // OR (~B)
		A = 32'h00000000;	B = 32'h00000001;	F = 3'd5;	#10;
        if((Y !== 32'hFFFFFFFE) || (zero != 0)) begin
            $display("TC-19 failed.");
            $display("Expected: Y = FFFFFFFE, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;
		A = 32'h00000000;	B = 32'h00000000;	F = 3'd5;	#10;
        if((Y !== 32'hFFFFFFFF) || (zero != 0)) begin
            $display("TC-20 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0");
            $display("Results: Y = %h, zero = %d\n", Y, zero);
        end;	

		$display("finished!");
		$display("running overflow testbench...");

        // adds
        A = 32'h7FFFFFFF;   B = 32'h00000001;   F = 3'b010; #10;
        if( (Y !== 32'h80000000) ||  (zero !== 0)  || (OF !== 1) ) begin
            $display("TC-21 failed.");
            $display("Expected: Y = 80000000, zero = 0, OF = 1");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'h80000000;   B = 32'hFFFFFFFF;   F = 3'b010; #10;
        if( (Y !== 32'h7FFFFFFF) || (zero !== 0) || (OF !== 1) ) begin
            $display("TC-22 failed.");
            $display("Expected: Y = 7FFFFFFF, zero = 0, OF = 1");
            $display("Results: Y = %h, zero = %d, OF = %d\n",  Y, zero, OF);
        end;
        A = 32'h 7FFFFFFF;  B = 32'h80000000;   F = 3'b010; #10;
        if( (Y !== 32'hFFFFFFFF) || (zero !== 0) || (OF !== 0) ) begin
            $display("TC-23 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0, OF = 0");
            $display("Results: Y = %h, zero = %d, OF = %d\n",  Y, zero, OF);
        end;
 
        // subs
        A = 32'h80000000;   B = 32'h00000001;   F = 3'b110; #10;
        if( (Y !== 32'h7FFFFFFF) || (zero !== 0) || (OF !== 1)) begin
            $display("TC-24 failed.");
            $display("Expected: Y = 7FFFFFFF, zero = 0, OF = 1");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'h7FFFFFFF;   B = 32'hFFFFFFFF;   F = 3'b110; #10;
        if( (Y !== 32'h80000000) || (zero !== 0) || (OF !== 1)) begin
            $display("TC-25 failed.");
            $display("Expected: Y = 80000000, zero = 0, OF = 1");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'h7FFFFFFF;   B = 32'h80000000;   F = 3'b110; #10;
        if( (Y !== 32'hFFFFFFFF) || (zero !== 0) || (OF !== 1) ) begin
            $display("TC-26 failed.");
            $display("Expected: Y = FFFFFFFF, zero = 0, OF =1 ");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'h00000005;   B = 32'h00000002;   F = 3'b110; #10;
        if( (Y !== 32'h00000003) || (zero !== 0) || (OF !== 0) ) begin
            $display("TC-27 failed.");
            $display("Expected: Y = 00000003, zero = -, OF = -");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
 
        // slt
        A = 32'h0000007F;   B = 32'h00000006;   F = 3'b111; #10;
        if( (Y !== 32'h00000000) || (zero !== 1) || (OF !== 0) ) begin
            $display("TC-28 failed.");
            $display("Expected: Y = 00000000, zero = 1, OF = 0");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'h0000007F;   B = 32'hFFFFFFFA;   F = 3'b111; #10;
        if( (Y !== 32'h00000000) || (zero !== 1) || (OF !== 0) ) begin
            $display("TC-29 failed.");
            $display("Expected: Y = 00000000, zero = 1, OF = 0");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
        A = 32'hFFFFFFF9;   B = 32'hFFFFFFFA;   F = 3'b111; #10;
        if( (Y !== 32'h00000001) || (zero !== 0) || (OF !== 0) ) begin
            $display("TC-30 failed.");
            $display("Expected: Y = 00000001, zero = 0, OF = 0");
            $display("Results: Y = %h, zero = %d, OF = %d\n", Y, zero, OF);
        end;
 
        $display("finished running overflow testbench!");
		$display("running pattern matching testbench...");

		A = 32'hFFF7FFFF;	B = 32'h0040FFFF;	F = 3'b011;	#10;    
        if(Y !== 32'h10078005) begin
            $display("TC-31 failed.");
            $display("Expected: Y = 10078005");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'hEEEF1248;	B = 32'h0FF0F6E4;	F = 3'b011;	#10;    
        if(Y !== 32'h00080001) begin
            $display("TC-32 failed.");
            $display("Expected: Y = 00080001");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'h22221222;	B = 32'h0F002222;	F = 3'b011;	#10;    
        if(Y !== 32'h80080002) begin
            $display("TC-33 failed.");
            $display("Expected: Y = 80080002");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'h55A5A5A5;	B = 32'h00005A5A;	F = 3'b011;	#10;    
        if(Y !== 32'h08080002) begin
            $display("TC-34 failed.");
            $display("Expected: Y = 08080002");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'hFFFFFF1F;	B = 32'h0000FFF1;	F = 3'b011;	#10;    
        if(Y !== 32'h00080001) begin
            $display("TC-35 failed.");
            $display("Expected: Y = 00080001");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'hFFFFCC1F;	B = 32'h00FDFFF1;	F = 3'b011;	#10;   
        if(Y !== 32'h0ce00005) begin
            $display("TC-36 failed.");
            $display("Expected: Y = 0ce00005");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'hFFFFEAAA; B = 32'h0055FF55;	F = 3'b011;	#10;    
        if(Y !== 32'h00100001) begin
            $display("TC-37 failed.");
            $display("Expected: Y = 00100001");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'h0A55AA55;	B = 32'hF0F00A05;	F = 3'b011;	#10;    
        if(Y !== 32'h850A8006) begin
            $display("TC-38 failed.");
            $display("Expected: Y = 850A8006");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'h146EEAF0;	B = 32'hF5F58617;	F = 3'b011; #10;    
        if(Y !== 32'h10100002) begin
            $display("TC-39 failed.");
            $display("Expected: Y = 10100002");
            $display("Results: Y = %h\n", Y);
        end;

        A = 32'h55555555;	B = 32'hAAAAFFFF;	F = 3'b011;	#10;    
        if(Y !== 32'hAAAA8009) begin
            $display("TC-40 failed.");
            $display("Expected: Y = AAAA8009");
            $display("Results: Y = %h\n", Y);
        end;

        $display("finshed running pattern matching testbench!");
		$display("finished testing!");
	end
endmodule

