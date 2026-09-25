// -------------------------------------------------------------------------
// File: pc_adder.sv
// Description: Simple adder to calculate PC + 4 for the next instruction fetch.
// -------------------------------------------------------------------------

module pc_adder (
    input  logic [31:0] current_pc,
    output logic [31:0] next_pc
);

    // RISC-V instructions are 32-bit (4 bytes), so we step by 4.
    assign next_pc = current_pc + 32'd4;

endmodule