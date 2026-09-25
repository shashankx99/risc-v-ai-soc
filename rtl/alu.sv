// -------------------------------------------------------------------------
// File: alu.sv
// Description: Standard 32-bit Arithmetic Logic Unit.
// -------------------------------------------------------------------------

module alu (
    input  logic [31:0] a,          // Input A (always from Register 1)
    input  logic [31:0] b,          // Input B (from Register 2 OR Immediate)
    input  logic [3:0]  alu_ctrl,   // 4-bit control signal from ALU Decoder
    output logic [31:0] result,
    output logic        zero        // High if result is 0 (used for branching)
);

    always_comb begin
        case (alu_ctrl)
            4'b0000: result = a & b;          // AND
            4'b0001: result = a | b;          // OR
            4'b0010: result = a + b;          // ADD
            4'b0110: result = a - b;          // SUBTRACT
            4'b0111: result = (a < b) ? 1 : 0;// SLT (Set Less Than)
            4'b1100: result = ~(a | b);       // NOR
            default: result = 32'b0;
        endcase
    end

    // Zero flag logic
    assign zero = (result == 32'b0) ? 1'b1 : 1'b0;

endmodule