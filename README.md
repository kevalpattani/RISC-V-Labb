# RV32I Single-Cycle Processor

A modular 32-bit, single-cycle RISC-V processor core written in SystemVerilog. The design implements the RV32I base integer instruction set only. It does not implement the M, C, floating-point, CSR, or privileged extensions.

## Repository layout

```text
RV32I_Single_Cycle/
├── ALU/rtl.sv
├── ALU_Control/rtl.sv
├── Decoder/rtl.sv
├── IF_Stage/rtl.sv
├── Immediate_Generator/rtl.sv
├── Main_Control/rtl.sv
├── Register_File/rtl.sv
├── Single_Cycle_RISCV/rtl.sv
├── Writeback/rtl.sv
├── LICENSE
├── README.md
└── rnr-stage.yaml
```

The top module is `rv32i_single_cycle` in `Single_Cycle_RISCV/rtl.sv`. `rnr-stage.yaml` lists the top module and every source module instantiated by it.

## Implemented instructions

- Upper immediate and PC-relative: `LUI`, `AUIPC`
- Control flow: `JAL`, `JALR`, `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`
- Loads: `LB`, `LH`, `LW`, `LBU`, `LHU`
- Stores: `SB`, `SH`, `SW`
- Register-register and immediate arithmetic/logic: `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND`; `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI`

## Top-level interface

Inputs: `clk`, `reset`, `stall`, `instruction[31:0]`, `mem_out[31:0]`.

Outputs: `rs2_data[31:0]`, `alu_out[31:0]`, `mem_write`, `mem_read`, `fn3[2:0]`, `opcode[6:0]`, `address[31:0]`.

The reset PC is `0x80000000`. When `stall` is asserted, the PC holds its current value, register-file writes are disabled, and both memory control outputs are deasserted.

## External memory connection

Instruction memory is read combinationally from `address`; its 32-bit instruction word is supplied on `instruction`. The core updates `address` on the active clock edge to the sequential PC or a taken branch/jump target.

Data-memory behavior uses `alu_out` as the byte address, `fn3` as the access width/signedness selector, `rs2_data` as store data, and `mem_read` / `mem_write` as controls. For loads, the external data-memory adapter must select the correct byte or halfword lane and sign-extend `LB`/`LH` or zero-extend `LBU`/`LHU` to 32 bits before supplying the result as `mem_out`. `LW` supplies the aligned 32-bit word. Store byte-lane placement and write masking are likewise the responsibility of the external data-memory adapter, using `alu_out` and `fn3`.

The memory is external, so the interface assumes combinational instruction reads and load data available in the same cycle. The core itself does not contain instruction or data arrays.

## Integration

Compile all RTL files listed in `rnr-stage.yaml` together. Connect the external memory according to the interface description above. The core has no internal testbench or simulation harness in this submission.
