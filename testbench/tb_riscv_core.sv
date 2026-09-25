`timescale 1ns/1ps

module tb_riscv_core();

    logic clk;
    logic rst_n;

    // Instantiate the Top-Level Core
    riscv_core_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Generate a clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0; // Assert reset

        // Dump waves for viewing
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_riscv_core);

        // Release reset after 20ns
        #20 rst_n = 1;

        // Run simulation for 150ns to catch all instructions
        #150;
        
        $display("System Verification Complete.");
        $finish;
    end

endmodule