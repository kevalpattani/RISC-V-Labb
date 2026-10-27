module imem (
    input  logic [31:0] a,
    output logic [31:0] rd
);
    logic [31:0] RAM [0:63];

    // Put 64 hexadecimal 32-bit instruction words in program.txt at the
    // simulation working directory (one word per line).
    initial begin
        $readmemh("program.txt", RAM);
    end

    // The CPU address is byte-addressed; each entry stores one 32-bit word.
    always_comb begin
        rd = RAM[a[7:2]];
    end
endmodule
