module single_cycle_riscv (
    input logic clk, reset, stall,
    input logic [31:0] instruction, mem_out,
    output logic [31:0] rs2_data, alu_out,
    output logic mem_write, mem_read,
    output logic [2:0] fn3,
    output logic [6:0] opcode,
    output logic [31:0] address
);
    logic [31:0] pc_new, rs1_data, imm_out, wb_data, pc_ex_out;
    logic [6:0] opcode_out_d, imm11_5;
    logic [2:0] fn3_out_d, aluop;
    logic fn7_5, branch, mux_inp, alu_src, and_out_ex;
    logic [1:0] memtoreg;
    logic mem_write_d, mem_read_d;

    if_stage u_if_stage (
        .clk(clk), .reset(reset), .stall(stall), .and_out(and_out_ex),
        .pc_signed_offset(pc_ex_out), .address(address), .pc_new(pc_new)
    );
    id_stage u_id_stage (
        .clk(clk), .reset(reset), .stall(stall), .instruction(instruction), .wb_data(wb_data),
        .rs1_data(rs1_data), .rs2_data(rs2_data), .imm_out(imm_out),
        .opcode_out_d(opcode_out_d), .imm11_5(imm11_5), .fn3_out_d(fn3_out_d),
        .fn7_5(fn7_5), .aluop(aluop), .memtoreg(memtoreg), .branch(branch),
        .mem_write(mem_write_d), .mem_read(mem_read_d), .alu_src(alu_src), .mux_inp(mux_inp)
    );
    ex_stage u_ex_stage (
        .rs1_data(rs1_data), .rs2_data(rs2_data), .imm_out(imm_out), .address(address),
        .branch(branch), .alu_src(alu_src), .fn7_5(fn7_5), .mux_inp(mux_inp),
        .fn3(fn3_out_d), .imm11_5(imm11_5), .aluop(aluop), .opcode(opcode_out_d),
        .and_out_ex(and_out_ex), .alu_out(alu_out), .pc_ex_out(pc_ex_out)
    );
    wb_stage u_wb_stage (
        .mem_out(mem_out), .alu_out(alu_out), .return_addr(pc_new), .imm_out(imm_out),
        .pc_signed_offset(pc_ex_out), .memtoreg(memtoreg), .opcode_out_d(opcode_out_d), .wb_data(wb_data)
    );
    always_comb begin
        opcode = opcode_out_d;
        fn3 = fn3_out_d;
        mem_write = mem_write_d && !stall;
        mem_read = mem_read_d && !stall;
    end
endmodule
