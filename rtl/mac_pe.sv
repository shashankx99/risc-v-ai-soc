// -------------------------------------------------------------------------
// File: mac_pe.sv
// Description: A single 8-bit signed Processing Element (Multiplier)
// -------------------------------------------------------------------------

module mac_pe (
    input  logic signed [7:0]  activation,
    input  logic signed [7:0]  weight,
    output logic signed [15:0] product
);

    // Multiply the two 8-bit signed numbers to get a 16-bit result
    assign product = activation * weight;

endmodule