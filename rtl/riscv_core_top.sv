// -------------------------------------------------------------------------
// File: riscv_core_top.sv
// Description: Top-level wrapper integrating the RISC-V baseline core 
//              WITH the Custom AI Hardware Accelerator.
// -------------------------------------------------------------------------
import riscv_core_pkg::*;

module riscv_core_top (
    input logic clk,
    input logic rst_n
);

    // Internal Wires
    logic [31:0] pc_current, pc_next;
    logic [31:0] instr;
    
    // Control Signals
    logic branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    logic custom_ai_en; // OUR CUSTOM AI TRIGGER WIRE
    logic [1:0] alu_op;
    logic [3:0] alu_ctrl;
    
    // Register & Data Signals
    logic [31:0] rs1_data, rs2_data, imm_out, alu_in_b;
    logic [31:0] alu_result, dot_result, wb_data; // Added dot_result
    logic alu_zero;

    // 1. Instruction Fetch (IF)
    pc_adder u_pc_adder (.current_pc(pc_current), .next_pc(pc_next));
    pc_reg u_pc_reg (.clk(clk), .rst_n(rst_n), .stall(1'b0), .pc_in(pc_next), .pc_out(pc_current));
    instr_mem u_instr_mem (.pc(pc_current), .instr(instr));

    // 2. Instruction Decode (ID)
    control_unit u_control_unit (
        .opcode       (instr[6:0]),
        .branch       (branch),
        .mem_read     (mem_read),
        .mem_to_reg   (mem_to_reg),
        .mem_write    (mem_write),
        .alu_src      (alu_src),
        .reg_write    (reg_write),
        .alu_op       (alu_op),
        .custom_ai_en (custom_ai_en) // Wiring the trigger
    );

    reg_file u_reg_file (
        .clk      (clk),
        .rst_n    (rst_n),
        .rs1_addr (instr[19:15]),
        .rs2_addr (instr[24:20]),
        .rs1_data (rs1_data),
        .rs2_data (rs2_data),
        .we       (reg_write),
        .rd_addr  (instr[11:7]),
        .rd_data  (wb_data) 
    );

    imm_gen u_imm_gen (.instr(instr), .imm_out(imm_out));

    // 3. Execute (EX) - DUAL PATHWAY
    alu_control u_alu_control (.alu_op(alu_op), .funct3(instr[14:12]), .funct7_5(instr[30]), .alu_ctrl(alu_ctrl));
    
    assign alu_in_b = (alu_src) ? imm_out : rs2_data;

    // PATH A: Standard Math
    alu u_alu (
        .a        (rs1_data),
        .b        (alu_in_b),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // PATH B: Custom AI Hardware Integration
    ai_dot_engine u_ai_engine (
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data),
        .dot_result (dot_result)
    );

    // 4. Write-Back (WB) - THE MULTIPLEXER
    // If our AI command is active, write back the neural math. 
    // Otherwise, write back standard ALU math.
    assign wb_data = (custom_ai_en) ? dot_result : alu_result; 

endmodule