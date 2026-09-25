`timescale 1ns/1ps

module tb_ai_dot_engine();

    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] out;

    // Instantiate the AI Engine
    ai_dot_engine dut (
        .rs1_data(rs1),
        .rs2_data(rs2),
        .dot_result(out)
    );

    initial begin
        $dumpfile("dump_ai.vcd");
        $dumpvars(0, tb_ai_dot_engine);

        $display("Starting AI Engine Test...");

        // TEST CASE 1: Simple Positive Numbers
        // rs1 = { 0x01, 0x02, 0x03, 0x04 } 
        // rs2 = { 0x01, 0x01, 0x01, 0x01 }
        rs1 = 32'h01_02_03_04;
        rs2 = 32'h01_01_01_01;
        #10;
        // Expected Math: (1*1) + (2*1) + (3*1) + (4*1) = 1 + 2 + 3 + 4 = 10
        $display("Test 1 Result: %d (Expected: 10)", out);

        // TEST CASE 2: Neural Network Weights (Negative Numbers)
        // rs1 (Activations) = { 2, 2, 2, 2 }  -> 32'h02_02_02_02
        // rs2 (Weights)     = { -1, 3, -2, 5} -> 32'hFF_03_FE_05
        rs1 = 32'h02_02_02_02;
        rs2 = 32'hFF_03_FE_05;
        #10;
        // Expected Math: (2*-1) + (2*3) + (2*-2) + (2*5) = -2 + 6 - 4 + 10 = 10
        $display("Test 2 Result: %d (Expected: 10)", out);

        #10 $finish;
    end
endmodule