module register_file (
    input  logic        clk,
    input  logic        reset,
    input  logic        write_enable,
    input  logic [4:0]  read_address1,
    input  logic [4:0]  read_address2,
    input  logic [4:0]  write_address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
    logic [31:0] registers [0:31];
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (write_enable && (write_address != 5'b0)) begin
            registers[write_address] <= write_data;
        end
    end

    always_comb begin
        read_data1 = (read_address1 == 5'b0) ? 32'b0 : registers[read_address1];
        read_data2 = (read_address2 == 5'b0) ? 32'b0 : registers[read_address2];
    end
endmodule
