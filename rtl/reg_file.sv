// -------------------------------------------------------------------------
// File: reg_file.sv
// Description: 32x32-bit Register File with 2 read ports and 1 write port.
//              Register x0 is hardwired to 0.
// -------------------------------------------------------------------------

module reg_file (
    input  logic        clk,
    input  logic        rst_n,
    
    // Read Port 1
    input  logic [4:0]  rs1_addr, // 5 bits can address 32 registers
    output logic [31:0] rs1_data,
    
    // Read Port 2
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs2_data,
    
    // Write Port
    input  logic        we,       // Write Enable
    input  logic [4:0]  rd_addr,  // Destination register address
    input  logic [31:0] rd_data   // Data to write
);

    // Array of 32 registers, each 32 bits wide
    logic [31:0] registers [31:0];
    integer i;

    // Read Logic (Asynchronous read)
    // If address is 0, output 0. Otherwise, output register contents.
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    // Write Logic (Synchronous write)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers on reset
            for (i = 1; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (we && (rd_addr != 5'b0)) begin
            // Write data if Write Enable is high AND we are not trying to write to x0
            registers[rd_addr] <= rd_data;
        end
    end

endmodule