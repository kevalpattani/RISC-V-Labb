module extend (
    input  logic [31:7] instr,
    input  logic [1:0]  immsrc,
    output logic [31:0] immext
);
    always_comb begin
        case (immsrc)
            2'b00: // I-type: imm[11:0]
                immext = {{20{instr[31]}}, instr[31:20]};

            2'b01: // S-type: imm[11:5] | imm[4:0]
                immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // This repository's datapath computes PC + (ImmExt << 1), so
            // B/J outputs omit the implicit low zero bit here.
            2'b10: // B-type bits imm[12:1]
                immext = {{20{instr[31]}}, instr[31], instr[7],
                          instr[30:25], instr[11:8]};

            2'b11: // J-type bits imm[20:1]
                immext = {{12{instr[31]}}, instr[31], instr[19:12],
                          instr[20], instr[30:21]};

            default:
                immext = 32'b0;
        endcase
    end
endmodule
