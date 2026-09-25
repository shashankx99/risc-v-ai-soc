// -------------------------------------------------------------------------
// File: ai_dot_engine.sv
// Description: 4-Lane SIMD Dot Product Engine for AI Acceleration.
//              Takes two 32-bit registers (packed with 8-bit values), 
//              multiplies them in parallel, and sums the results.
// -------------------------------------------------------------------------

module ai_dot_engine (
    input  logic [31:0] rs1_data, // Contains four 8-bit activations
    input  logic [31:0] rs2_data, // Contains four 8-bit weights
    output logic [31:0] dot_result
);

    // Internal wires to hold the 16-bit products from our 4 PEs
    logic signed [15:0] prod_0, prod_1, prod_2, prod_3;

    // ---------------------------------------------------------------------
    // 1. Parallel Multipliers (The MAC PEs)
    // ---------------------------------------------------------------------
    // Extract bytes from the 32-bit registers and feed them to the PEs
    mac_pe pe0 (
        .activation (rs1_data[7:0]), 
        .weight     (rs2_data[7:0]), 
        .product    (prod_0)
    );

    mac_pe pe1 (
        .activation (rs1_data[15:8]), 
        .weight     (rs2_data[15:8]), 
        .product    (prod_1)
    );

    mac_pe pe2 (
        .activation (rs1_data[23:16]), 
        .weight     (rs2_data[23:16]), 
        .product    (prod_2)
    );

    mac_pe pe3 (
        .activation (rs1_data[31:24]), 
        .weight     (rs2_data[31:24]), 
        .product    (prod_3)
    );

    // ---------------------------------------------------------------------
    // 2. The Adder Tree (Summing the products)
    // ---------------------------------------------------------------------
    // Sign-extend the 16-bit products to 32 bits, then add them all together.
    assign dot_result = {{16{prod_0[15]}}, prod_0} + 
                        {{16{prod_1[15]}}, prod_1} + 
                        {{16{prod_2[15]}}, prod_2} + 
                        {{16{prod_3[15]}}, prod_3};

endmodule