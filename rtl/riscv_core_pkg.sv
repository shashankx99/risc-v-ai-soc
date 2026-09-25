// -------------------------------------------------------------------------
// File: riscv_core_pkg.sv
// Description: Global package defining opcodes, formats, and constants 
//              for the custom RISC-V AI SoC.
// -------------------------------------------------------------------------

package riscv_core_pkg;

    // ---------------------------------------------------------------------
    // 1. Standard RISC-V Opcodes (Base RV32I)
    // ---------------------------------------------------------------------
    typedef enum logic [6:0] {
        OPCODE_R_TYPE = 7'b0110011, // Standard Arithmetic (ADD, SUB, XOR)
        OPCODE_I_TYPE = 7'b0010011, // Immediate Arithmetic (ADDI, XORI)
        OPCODE_LOAD   = 7'b0000011, // Load from memory (LW, LB)
        OPCODE_STORE  = 7'b0100011, // Store to memory (SW, SB)
        OPCODE_BRANCH = 7'b1100011, // Branch instructions (BEQ, BNE)
        OPCODE_JAL    = 7'b1101111, // Jump and Link
        OPCODE_JALR   = 7'b1100111, // Jump and Link Register
        OPCODE_LUI    = 7'b0110111  // Load Upper Immediate
    } rv32_opcode_e;

    // ---------------------------------------------------------------------
    // 2. Custom AI ISA Extension Opcodes
    // ---------------------------------------------------------------------
    typedef enum logic [6:0] {
        // Utilizing the RISC-V "custom-0" opcode space
        OPCODE_CUSTOM_AI = 7'b0001011 
    } custom_opcode_e;

    // ---------------------------------------------------------------------
    // 3. AI Accelerator Function Codes (funct3)
    // ---------------------------------------------------------------------
    typedef enum logic [2:0] {
        FUNC3_MAC8  = 3'b000, // 8-bit Multiply-Accumulate
        FUNC3_MAC16 = 3'b001, // 16-bit Multiply-Accumulate (Future expansion)
        FUNC3_RELU  = 3'b010  // Hardware Rectified Linear Unit activation
    } ai_func3_e;

    // ---------------------------------------------------------------------
    // 4. Standard ALU Function Codes (funct3)
    // ---------------------------------------------------------------------
    typedef enum logic [2:0] {
        FUNC3_ADD_SUB = 3'b000,
        FUNC3_SLL     = 3'b001,
        FUNC3_SLT     = 3'b010,
        FUNC3_SLTU    = 3'b011,
        FUNC3_XOR     = 3'b100,
        FUNC3_SRL_SRA = 3'b101,
        FUNC3_OR      = 3'b110,
        FUNC3_AND     = 3'b111
    } alu_func3_e;

    // ---------------------------------------------------------------------
    // 5. System Parameters
    // ---------------------------------------------------------------------
    parameter XLEN = 32; // 32-bit architecture

endpackage