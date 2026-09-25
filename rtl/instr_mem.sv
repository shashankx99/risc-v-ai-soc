// -------------------------------------------------------------------------
// File: instr_mem.sv
// Description: Instruction Memory (ROM). Simulates the memory holding our code.
// -------------------------------------------------------------------------

module instr_mem #(
    parameter MEM_DEPTH = 256 // Number of 32-bit words
)(
    input  logic [31:0] pc,       // Address from Program Counter
    output logic [31:0] instr     // 32-bit Instruction fetched
);

    // Create an array of 32-bit logic vectors
    logic [31:0] rom [0:MEM_DEPTH-1];

    // Initialize the memory for simulation
    initial begin
        // $readmemh loads a hex file into the 'rom' array.
        // We will create 'program.hex' later when we write our test code.
        $readmemh("program.hex", rom); 
    end

    // RISC-V memory is byte-addressed, meaning addresses jump by 4 (0, 4, 8, 12).
    // Our array is word-addressed (0, 1, 2, 3).
    // Therefore, we ignore the bottom 2 bits of the PC (pc[31:2]) to align it.
    assign instr = rom[pc[31:2]];

endmodule