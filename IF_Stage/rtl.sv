module if_stage (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic        take_branch,
    input  logic [31:0] branch_target,
    output logic [31:0] address
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            address <= 32'h8000_0000;
        else if (!stall) begin
            if (take_branch)
                address <= branch_target;
            else
                address <= address + 32'd4;
        end
    end
endmodule
