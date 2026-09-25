// -------------------------------------------------------------------------
// File: alu_control.sv
// Description: Translates generic ALU_Op and instruction fields into specific 
//              4-bit ALU control signals.
// -------------------------------------------------------------------------

module alu_control (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic       funct7_5, // Bit 30 of the instruction
    output logic [3:0] alu_ctrl
);

    always_comb begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // Load/Store -> Add to calculate address
            2'b01: alu_ctrl = 4'b0110; // Branch -> Subtract to compare
            2'b11: begin               // I-Type (Immediate)
                case (funct3)
                    3'b000: alu_ctrl = 4'b0010; // ADDI
                    3'b111: alu_ctrl = 4'b0000; // ANDI
                    3'b110: alu_ctrl = 4'b0001; // ORI
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            2'b10: begin               // R-Type
                case (funct3)
                    3'b000: begin
                        if (funct7_5 == 1'b1) alu_ctrl = 4'b0110; // SUB
                        else                  alu_ctrl = 4'b0010; // ADD
                    end
                    3'b111: alu_ctrl = 4'b0000; // AND
                    3'b110: alu_ctrl = 4'b0001; // OR
                    3'b010: alu_ctrl = 4'b0111; // SLT
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end
endmodule