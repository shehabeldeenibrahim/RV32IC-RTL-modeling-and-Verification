# RV32IC-RTL-modeling-and-Verification

Verilog RTL of a pipelined CPU that implements the RV32IC ISA. 
All instructions implemented except of FENCE, FENCE.I. 
Partial support for the CSR instructions and interrupts is implemented. 
The CPU design reflects the following constraints:
1. A single ported memory is used for both data and instructions
This constraint introduces structural hazards that degrade the CPU performance and increase the effective CPI
drastically. One solution, is to issue an instruction every 2 clock cycles (effective CPI=2). By doing so, memory accesses
of different instruction won’t occur on the same clock cycle. The same goes for the register file.
Pipelined CPU with Every-other-Cycle Instruction Issuing
This can be seen as the CPU executes each instruction in 6 cycles divided into 3 stages. Each stage uses 2 clock cycles (C0
and C1).
  • Stage 0: Instruction Fetch (C0) and Registers read (C1).
  • Stage 1: ALU operation (C0) and Memory read/write (C1).
  • Stage 2: Register write back (C0). C1 is not used by this stage.
2. A memory transaction is done in 2 phases. Address phase (one clock cycle) followed by a data phase (one or more
clock cycles). The memory has a ready signal (output) that indicate the completion of the data phase.
3. A dual ported memory is used for the register file.

B. Verification framework that consists of functional tests, automatically generated pseudo-random tests as well as scripts to
automate the testing process. RISC-V official compliance test suite was used.

