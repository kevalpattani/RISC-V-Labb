module alu_control (
    input  logic [6:0] opcode,
    input  logic [2:0] fn3,
    input  logic [6:0] fn7,
    output logic [3:0] operation
);
    localparam logic [3:0] ALU_ADD=4'd0, ALU_SUB=4'd1, ALU_SLL=4'd2,
        ALU_SLT=4'd3, ALU_SLTU=4'd4, ALU_XOR=4'd5, ALU_SRL=4'd6,
        ALU_SRA=4'd7, ALU_OR=4'd8, ALU_AND=4'd9, ALU_COPY_B=4'd10;
    always_comb begin
        operation = ALU_ADD;
        case (opcode)
            7'b0110011, 7'b0010011: begin
                case (fn3)
                    3'b000: operation = (opcode == 7'b0110011 && fn7[5]) ? ALU_SUB : ALU_ADD;
                    3'b001: operation = ALU_SLL;
                    3'b010: operation = ALU_SLT;
                    3'b011: operation = ALU_SLTU;
                    3'b100: operation = ALU_XOR;
                    3'b101: operation = fn7[5] ? ALU_SRA : ALU_SRL;
                    3'b110: operation = ALU_OR;
                    3'b111: operation = ALU_AND;
                    default: operation = ALU_ADD;
                endcase
            end
            7'b0110111: operation = ALU_COPY_B;
            default: operation = ALU_ADD;
        endcase
    end
endmodule
