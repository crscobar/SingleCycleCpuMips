module testbench_u32();
    logic unsigned [31:0] A, B;
    logic lt;

    comparator_u32 dut(A, B, lt);

    initial begin
        A = 32'hFFFFFFFF;   B = 32'h00000000;   #10;
        A = 32'hFFFFFFE6;   B = 32'h0000001B;   #10;
        A = 32'hFFFFFFE5;   B = 32'h0000001B;   #10;
        A = 32'h0000001B;   B = 32'h0000001B;   #10;
    end
endmodule
