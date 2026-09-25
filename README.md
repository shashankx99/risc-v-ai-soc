# RISC-V AI SoC

## Overview

This project implements a 5-stage pipelined RISC-V processor with an integrated AI engine for accelerating 8-bit dot-product operations.

## Features

- 5-stage RISC-V pipeline
- Custom `mac.8` instruction
- 4-lane SIMD MAC operation
- SystemVerilog RTL
- Functional simulation
- FPGA implementation using Vivado

## Architecture

The processor contains:

- Instruction Fetch
- Instruction Decode
- Execute
- Memory
- Write Back
- Register File
- ALU
- AI Engine
- MAC Processing Elements

## AI Engine

The custom `mac.8` instruction performs four 8-bit multiplications in parallel.


rs1 = [A3 A2 A1 A0]
rs2 = [B3 B2 B1 B0]

Result =
A0×B0 + A1×B1 + A2×B2 + A3×B3

Tools
SystemVerilog
Vivado
RISC-V ISA
FPGA

| Resource        | Usage |
| --------------- | ----: |
| Slice LUTs      |   444 |
| Slice Registers |   429 |
| DSP Blocks      |     0 |
| BRAM            |     0 |






