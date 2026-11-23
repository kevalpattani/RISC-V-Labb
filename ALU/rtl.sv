module alu (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [3:0]  operation,
    output logic [31:0] result,
    output logic        zero
);
    always_comb begin
        case (operation)
            4'd0: result = operand_a + operand_b;
            4'd1: result = operand_a - operand_b;
            4'd2: result = operand_a << operand_b[4:0];
            4'd3: result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            4'd4: result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            4'd5: result = operand_a ^ operand_b;
            4'd6: result = operand_a >> operand_b[4:0];
            4'd7: result = $signed(operand_a) >>> operand_b[4:0];
            4'd8: result = operand_a | operand_b;
            4'd9: result = operand_a & operand_b;
            4'd10: result = operand_b;
            default: result = 32'b0;
        endcase
        zero = (result == 32'b0);
    end
endmodule
