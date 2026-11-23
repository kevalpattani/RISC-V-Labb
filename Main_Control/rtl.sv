module main_control (
    input  logic [6:0] opcode,
    output logic       use_immediate,
    output logic       register_write,
    output logic       memory_read,
    output logic       memory_write,
    output logic       writeback_memory,
    output logic       writeback_pc4,
    output logic       auipc,
    output logic       lui,
    output logic       is_branch,
    output logic       is_jal,
    output logic       is_jalr
);
    always_comb begin
        use_immediate   = 1'b0;
        register_write  = 1'b0;
        memory_read     = 1'b0;
        memory_write    = 1'b0;
        writeback_memory= 1'b0;
        writeback_pc4   = 1'b0;
        auipc           = 1'b0;
        lui             = 1'b0;
        is_branch       = 1'b0;
        is_jal          = 1'b0;
        is_jalr         = 1'b0;
        case (opcode)
            7'b0110011: register_write = 1'b1;
            7'b0010011: begin use_immediate = 1'b1; register_write = 1'b1; end
            7'b0000011: begin use_immediate = 1'b1; register_write = 1'b1; memory_read = 1'b1; writeback_memory = 1'b1; end
            7'b0100011: begin use_immediate = 1'b1; memory_write = 1'b1; end
            7'b1100011: is_branch = 1'b1;
            7'b1101111: begin register_write = 1'b1; writeback_pc4 = 1'b1; is_jal = 1'b1; end
            7'b1100111: begin use_immediate = 1'b1; register_write = 1'b1; writeback_pc4 = 1'b1; is_jalr = 1'b1; end
            7'b0110111: begin register_write = 1'b1; lui = 1'b1; end
            7'b0010111: begin register_write = 1'b1; auipc = 1'b1; end
            default: begin end
        endcase
    end
endmodule
