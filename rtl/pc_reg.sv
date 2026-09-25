// -------------------------------------------------------------------------
// File: pc_reg.sv
// Description: Program Counter Register. Holds the 32-bit instruction address.
// -------------------------------------------------------------------------

module pc_reg (
    input  logic        clk,
    input  logic        rst_n,   // Active-low reset
    input  logic        stall,   // High to freeze the PC (useful for pipeline hazards later)
    input  logic [31:0] pc_in,   // Next address (usually PC + 4, or a branch target)
    output logic [31:0] pc_out   // Current address
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset to base address (e.g., boot ROM start address)
            pc_out <= 32'h0000_0000; 
        end else if (!stall) begin
            // Update PC on clock edge if not stalled
            pc_out <= pc_in;
        end
    end

endmodule