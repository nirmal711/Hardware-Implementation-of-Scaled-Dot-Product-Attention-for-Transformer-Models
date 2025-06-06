# Hardware-Implementation-of-Scaled-Dot-Product-Attention-for-Transformer-Models

This project implements the Scaled Dot-Product Attention mechanism, a fundamental component of Transformer models, using a custom hardware accelerator design.

## 🧠 Project Overview

The hardware design performs a sequence of matrix operations to emulate the attention mechanism in Transformers:

Input Matrix (I) × Weight Matrix (W) → generates Query (Q), Key (K), and Value (V) matrices

Q × Kᵗ → computes the Score Matrix (S)

S × V → computes the Attention Output (Z)

Final results are stored in Output SRAM

## 📊 Performance
**Tech Library:** `NangateOpenCellLibrary_PDKv1_2_v2008_10_slow_nldm.db`

**Pipelined MAC**	
- **Clock Period:** 5.3 ns 
- **Logic Area:** 6325.746 µm²  

**Non-Pipelined MAC**	
- **Clock Period:** 5.6 ns 
- **Logic Area:** 5973.828 µm²  

## 🛠️ Optimization Summary
1. MAC Computation Logic
- Pre-computed operands (op_a, op_b) to simplify multiplier-accumulator logic
2. Pipelined MAC Operation
- Divided multiplication and accumulation into pipeline stages for improved clock speed
3. FSM State Reduction via State Reuse
- Reused FSM states across similar matrix multiplication steps to reduce control logic complexity and area

---

## 🚀 How to Run

### 1. Unzip the Project

```bash
unzip ece564_F24.zip
cd ece564_F24
```
### 2. Run Simulation

Go to the run/ directory:
```bash
cd run
```
To run with UI (debug mode):
```bash
make debug
```
To run without UI:
```bash
make eval
```
### 3. Run Synthesis
Go to the synthesis/ directory:
```bash
cd synthesis
```
Run synthesis with specified clock period:
```bash
make all CLOCK_PER=5.3
```
