module writeback (
    input  logic [31:0] alu_result,
    input  logic [31:0] memory_data,
    input  logic [31:0] pc_plus4,
    input  logic        select_memory,
    input  logic        select_pc_plus4,
    output logic [31:0] write_data
);
    always_comb begin
        if (select_pc_plus4)
            write_data = pc_plus4;
        else if (select_memory)
            write_data = memory_data;
        else
            write_data = alu_result;
    end
endmodule
