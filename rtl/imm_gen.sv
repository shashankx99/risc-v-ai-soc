// -------------------------------------------------------------------------
// File: imm_gen.sv
// Description: Extracts and sign-extends immediate values from instructions.
// -------------------------------------------------------------------------
import riscv_core_pkg::*;

module imm_gen (
    input  logic [31:0] instr,
    output logic [31:0] imm_out
);

    logic [6:0] opcode;
    assign opcode = instr[6:0];

    always_comb begin
        case (opcode)
            // I-Type (e.g., ADDI, LW)
            OPCODE_I_TYPE, OPCODE_LOAD, OPCODE_JALR: 
                imm_out = {{20{instr[31]}}, instr[31:20]};
                
            // S-Type (e.g., SW)
            OPCODE_STORE: 
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                
            // B-Type (e.g., BEQ)
            OPCODE_BRANCH: 
                imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                
            // U-Type (e.g., LUI)
            OPCODE_LUI: 
                imm_out = {instr[31:12], 12'b0};
                
            // J-Type (e.g., JAL)
            OPCODE_JAL: 
                imm_out = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                
            // Default (R-Type and our Custom AI instruction don't use immediates this way)
            default: 
                imm_out = 32'b0;
        endcase
    end

endmodule