module rv32i_single_cycle (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] mem_out,
    output logic [31:0] rs2_data,
    output logic [31:0] alu_out,
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,
    output logic [6:0]  opcode,
    output logic [31:0] address
);
    logic [4:0] rd, rs1, rs2;
    logic [6:0] fn7;
    logic [31:0] immediate, rs1_data, operand_b, alu_result, alu_raw, write_data;
    logic [31:0] pc_plus4, branch_target;
    logic [3:0] alu_operation;
    logic use_immediate, register_write, writeback_memory, writeback_pc4;
    logic control_mem_read, control_mem_write;
    logic auipc, lui, is_branch, is_jal, is_jalr;
    logic branch_condition, take_branch, alu_zero;

    decoder u_decoder (
        .instruction(instruction), .opcode(opcode), .rd(rd), .fn3(fn3),
        .rs1(rs1), .rs2(rs2), .fn7(fn7)
    );
    immediate_generator u_imm_generator (
        .instruction(instruction), .opcode(opcode), .immediate(immediate)
    );
    main_control u_main_control (
        .opcode(opcode), .use_immediate(use_immediate), .register_write(register_write),
        .memory_read(control_mem_read), .memory_write(control_mem_write), .writeback_memory(writeback_memory),
        .writeback_pc4(writeback_pc4), .auipc(auipc), .lui(lui), .is_branch(is_branch),
        .is_jal(is_jal), .is_jalr(is_jalr)
    );
    register_file u_register_file (
        .clk(clk), .reset(reset), .write_enable(register_write && !stall),
        .read_address1(rs1), .read_address2(rs2), .write_address(rd),
        .write_data(write_data), .read_data1(rs1_data), .read_data2(rs2_data)
    );
    alu_control u_alu_control (
        .opcode(opcode), .fn3(fn3), .fn7(fn7), .operation(alu_operation)
    );

    always_comb begin
        operand_b = use_immediate ? immediate : rs2_data;
        alu_result = auipc ? (address + immediate) : alu_raw;
        pc_plus4 = address + 32'd4;
        branch_target = address + immediate;
        if (is_jalr)
            branch_target = (rs1_data + immediate) & 32'hffff_fffe;

        branch_condition = 1'b0;
        case (fn3)
            3'b000: branch_condition = (rs1_data == rs2_data);
            3'b001: branch_condition = (rs1_data != rs2_data);
            3'b100: branch_condition = ($signed(rs1_data) < $signed(rs2_data));
            3'b101: branch_condition = ($signed(rs1_data) >= $signed(rs2_data));
            3'b110: branch_condition = (rs1_data < rs2_data);
            3'b111: branch_condition = (rs1_data >= rs2_data);
            default: branch_condition = 1'b0;
        endcase
        take_branch = (is_branch && branch_condition) || is_jal || is_jalr;
        alu_out = alu_result;
        mem_read = control_mem_read && !stall;
        mem_write = control_mem_write && !stall;
    end

    alu u_alu (
        .operand_a(rs1_data), .operand_b(operand_b), .operation(alu_operation),
        .result(alu_raw), .zero(alu_zero)
    );
    writeback u_writeback (
        .alu_result(alu_result), .memory_data(mem_out), .pc_plus4(pc_plus4),
        .select_memory(writeback_memory), .select_pc_plus4(writeback_pc4), .write_data(write_data)
    );
    if_stage u_if_stage (
        .clk(clk), .reset(reset), .stall(stall), .take_branch(take_branch),
        .branch_target(branch_target), .address(address)
    );

endmodule
