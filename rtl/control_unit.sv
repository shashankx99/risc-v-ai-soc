// -------------------------------------------------------------------------
// File: control_unit.sv
// Description: Generates control signals based on the instruction opcode.
// -------------------------------------------------------------------------
import riscv_core_pkg::*;

module control_unit (
    input  logic [6:0] opcode,
    
    // Standard Control Signals
    output logic       branch,
    output logic       mem_read,
    output logic       mem_to_reg,
    output logic       mem_write,
    output logic       alu_src,    // 0 = Register, 1 = Immediate
    output logic       reg_write,
    output logic [1:0] alu_op,     // Tells ALU Control what type of math to do
    
    // Custom AI Control Signal
    output logic       custom_ai_en // High when our custom AI opcode is detected
);

    always_comb begin
        // Default all signals to 0 to prevent accidental writes
        branch       = 1'b0;
        mem_read     = 1'b0;
        mem_to_reg   = 1'b0;
        mem_write    = 1'b0;
        alu_src      = 1'b0;
        reg_write    = 1'b0;
        alu_op       = 2'b00;
        custom_ai_en = 1'b0; 

        case (opcode)
            OPCODE_R_TYPE: begin // Standard Math (ADD, SUB)
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end
            OPCODE_I_TYPE: begin // Immediate Math (ADDI)
                alu_src   = 1'b1;
                reg_write = 1'b1;
                alu_op    = 2'b11;
            end
            OPCODE_LOAD: begin   // Load Word (LW)
                alu_src   = 1'b1;
                mem_to_reg= 1'b1;
                reg_write = 1'b1;
                mem_read  = 1'b1;
                alu_op    = 2'b00; // ALU does addition for memory address
            end
            OPCODE_STORE: begin  // Store Word (SW)
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00; // ALU does addition for memory address
            end
            OPCODE_BRANCH: begin // Branch (BEQ)
                branch    = 1'b1;
                alu_op    = 2'b01; // ALU does subtraction to compare
            end
            
            // ---------------------------------------------------
            // THE SECRET SAUCE: Our Custom AI Instruction Trigger
            // ---------------------------------------------------
            OPCODE_CUSTOM_AI: begin 
                reg_write    = 1'b1; // We will write the MAC result back to a register
                custom_ai_en = 1'b1; // Activate the MAC array!
            end
        endcase
    end
endmodule