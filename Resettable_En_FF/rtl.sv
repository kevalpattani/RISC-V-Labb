module flopenr #(
    parameter WIDTH = 8
) (
    input  logic                 clk,
    input  logic                 reset,
    input  logic                 en,
    input  logic [WIDTH-1:0]     d,
    output logic [WIDTH-1:0]     q
);
    // Reset has priority; otherwise capture data only when enabled.
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            q <= '0;
        else if (en)
            q <= d;
    end
endmodule
