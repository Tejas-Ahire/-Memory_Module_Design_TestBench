# Verilog Synchronous Memory Project

A comprehensive Verilog-based verification project for a **Synchronous Single-Port RAM**. This repository contains the RTL design and a task-based directed testbench capable of memory backdoor loading, boundary testing, and randomized data validation.

## 📋 Features
* [cite_start]**Parameterized Design:** Depth and Width are configurable via a common header file[cite: 1, 4].
* [cite_start]**Handshaking Protocol:** Uses `valid_i` and `ready_o` signals to ensure synchronized data transfers[cite: 1, 2].
* [cite_start]**Task-Based Verification:** Modular testbench using specialized tasks for `reset`, `write`, and `read` operations[cite: 6, 7, 8].
* [cite_start]**Backdoor Operations:** Supports loading initial memory states from `data.h` and dumping memory contents to `output.bin` using system tasks[cite: 9, 10].
* [cite_start]**Multiple Test Scenarios:** Built-in testcase selector for partial, full, and boundary memory access.

---

## 🏗️ Architecture Overview

The memory operates on a synchronous clock. When `valid_i` is asserted, the memory provides a `ready_o` signal to acknowledge the transaction.


### Port Descriptions
| Port | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | [cite_start]Clock Signal [cite: 1] |
| `rst` | Input | 1 | [cite_start]Active High Reset (Clears all memory locations) [cite: 1] |
| `w_r_i` | Input | 1 | [cite_start]Write/Read select (1 = Write, 0 = Read) [cite: 1, 3] |
| `addr_i` | Input | `ADDR_WIDTH` | [cite_start]Memory Address [cite: 1] |
| `wdata_i` | Input | `WIDTH` | [cite_start]Data to be written [cite: 1] |
| `rdata_o` | Output | `WIDTH` | [cite_start]Data read from memory [cite: 2] |
| `valid_i` | Input | 1 | [cite_start]Signal indicating valid input signals [cite: 1] |
| `ready_o` | Output | 1 | [cite_start]Signal indicating memory is ready for access [cite: 2] |

---

## 📂 File Structure

| File | Description |
| :--- | :--- |
| `common.v` | Contains global macros for `DEPTH` and `WIDTH`. |
| `memoryProj.v` | [cite_start]The core Synchronous Memory RTL[cite: 1]. |
| `memoryProj_tb.v` | [cite_start]Task-based Testbench with directed testcases[cite: 4]. |
| `data.h` | [cite_start]Hex file used for backdoor memory loading[cite: 9]. |
| `output.bin` | [cite_start]Binary file generated for memory content dumping. |

---

## 🚀 Running in Questa Sim

Follow these steps to compile and simulate the project in the **Questa Sim** environment:

### 1. Setup and Compilation
```bash
# Create the work library
vlib work

# Compile the design and testbench (ensure common.v is in the same path)
vlog memoryProj_tb.v
