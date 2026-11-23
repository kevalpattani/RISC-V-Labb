# RV32I Single-Cycle RISC-V Processor

A modular 32-bit single-cycle RISC-V processor written in SystemVerilog. The folder names, per-module `rtl.sv` layout, module decomposition, top-level integration folder, and `rnr-stage.yaml` follow the course reference repository: [pranav0x2212/RISC-V-Single-Cycle](https://github.com/pranav0x2212/RISC-V-Single-Cycle).

## ISA scope

This implementation supports the RV32I integer operations: `LUI`, `AUIPC`, `JAL`, `JALR`, `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`, `LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, `SW`, and the RV32I integer register-register and immediate arithmetic, shift, comparison, and logic instructions. It does not implement M, C, floating-point, CSR, privileged, FENCE, ECALL, or EBREAK instructions.

## Repository structure

```text
RV32I_Single_Cycle/
├── ALU/rtl.sv
├── ALU_Control/rtl.sv
├── Decoder/rtl.sv
├── EX_Stage/rtl.sv
├── ID_Stage/rtl.sv
├── IF_Stage/rtl.sv
├── Immediate_Generator/rtl.sv
├── Main_Control/rtl.sv
├── Register_File/rtl.sv
├── Single_Cycle_RISCV/rtl.sv
├── WB_Stage/rtl.sv
├── LICENSE
├── README.md
└── rnr-stage.yaml
```

Top-level module: `single_cycle_riscv` in `Single_Cycle_RISCV/rtl.sv`. Each module instantiated by the top is listed in `rnr-stage.yaml`, including modules instantiated by ID and EX stages.

## Top-level ports

Inputs: `clk`, `reset`, `stall`, `instruction[31:0]`, `mem_out[31:0]`.

Outputs: `rs2_data[31:0]`, `alu_out[31:0]`, `mem_write`, `mem_read`, `fn3[2:0]`, `opcode[6:0]`, `address[31:0]`.

The PC asynchronously resets to `32'h8000_0000`. `stall` holds the PC and suppresses register-file writes and external memory read/write controls.

## External memory interface

Instruction memory is read combinationally using `address`; the selected 32-bit instruction is supplied on `instruction`. Data memory uses `alu_out` as the byte address, `fn3` as the access-width selector, `rs2_data` as store data, and `mem_read` / `mem_write` as controls.

The external data-memory adapter must align and extend load results before driving `mem_out`: sign-extend `LB` and `LH`, zero-extend `LBU` and `LHU`, and return the selected 32-bit value for `LW`. For stores, the adapter uses `alu_out` and `fn3` to place the low byte or halfword in the appropriate lane and generate the corresponding byte enables. The processor does not contain instruction or data memory arrays; the interface assumes combinational instruction reads and load data within the same processor cycle.

## Source manifest

`rnr-stage.yaml` uses the reference CI stage format and lists every RTL source needed to build the integration module. No testbench is included.
