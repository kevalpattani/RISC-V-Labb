module regfile (
    input  logic         clk,
    input  logic         we3,
    input  logic [4:0]   a1,
    input  logic [4:0]   a2,
    input  logic [4:0]   a3,
    input  logic [31:0]  wd3,
    output logic [31:0]  rd1,
    output logic [31:0]  rd2
);
    logic [31:0] rf [0:31];

    // Two combinational read ports. x0 is hardwired to zero.
    always_comb begin
        rd1 = (a1 == 5'd0) ? 32'b0 : rf[a1];
        rd2 = (a2 == 5'd0) ? 32'b0 : rf[a2];
    end

    // One synchronous write port; writes to x0 are discarded.
    always_ff @(posedge clk) begin
        if (we3 && (a3 != 5'd0))
            rf[a3] <= wd3;
    end
endmodule
