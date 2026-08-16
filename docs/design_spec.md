# APB Design Specification

## 1. Purpose

This document specifies the behavior to be verified in this project: the AMBA
APB protocol itself (generic, applies to any compliant APB slave), and the
specific documented interface/register behavior of the DUT selected for this
project.

Per project convention, this spec is written black-box — from the DUT's
documented interface, not by tracing its internal FSM logic line by line.

**Documentation-source note:** this DUT ships without a separate datasheet.
The only documentation available is the RTL file's header comment block
(module description, register address map, write/read cycle timing) and
port list. Those header comments — not the FSM implementation itself — are
the source for Section 3 below. This is treated the same as the FIFO
project's pointer-wraparound exception: an architecture-level fact taken
from available documentation because no independent source exists, not a
line-by-line trace of internal logic.

## 2. Protocol Specification — Generic APB (spec-mandated, DUT-agnostic)

This section describes rules that apply to **any** APB-compliant slave.
Nothing in this section is specific to the DUT chosen for this project.

### 2.1 Signals

| Signal    | Direction (master→slave unless noted) | Purpose |
|-----------|----------------------------------------|---------|
| `PCLK`    | —              | Clock. All APB activity is synchronous to this. |
| `PRESETn` | —              | Active-low reset. |
| `PADDR`   | master→slave   | Address of the register/location being accessed. |
| `PWRITE`  | master→slave   | 1 = write transaction, 0 = read transaction. |
| `PSEL`    | master→slave   | Selects this specific slave. One `PSEL` per slave on a shared bus. |
| `PENABLE` | master→slave   | Distinguishes SETUP phase (0) from ACCESS phase (1). |
| `PWDATA`  | master→slave   | Write data. Meaningful only when `PWRITE`=1. |
| `PSTRB`   | master→slave   | Byte-lane strobes for partial-word writes. APB4 addition — not present in APB2/APB3 slaves. |
| `PREADY`  | slave→master   | Slave asserts high when the current transaction is complete. Held low to insert wait states. |
| `PRDATA`  | slave→master   | Read data. Meaningful only when `PWRITE`=0, once `PREADY` is high. |
| `PSLVERR` | slave→master   | Optional. Asserted by the slave to flag an error on the current transaction. |

### 2.2 Transaction phases

Every APB transaction consists of exactly two phases:

1. **SETUP** (always exactly 1 cycle): the master drives `PADDR`, `PWRITE`,
   `PWDATA` (if writing), and asserts `PSEL`. `PENABLE` is low.
2. **ACCESS** (1 or more cycles): the master additionally asserts `PENABLE`,
   while holding `PADDR`/`PWRITE`/`PWDATA`/`PSEL` stable. The slave performs
   the requested operation. The ACCESS phase ends — and the transaction
   completes — on the first rising clock edge where `PREADY` is sampled high.

If the slave is not ready to complete in the first ACCESS cycle, it holds
`PREADY` low; the ACCESS phase extends by one cycle per wait state, with
all master-driven signals remaining stable throughout.

After completion, the bus returns to IDLE (`PSEL`=0) or directly begins a
new SETUP phase for a back-to-back transaction.

### 2.3 Signal stability rules

- `PADDR`, `PWRITE`, `PWDATA`, `PSTRB`, `PSEL` must remain stable for the
  entire duration of a transaction, from SETUP through the end of ACCESS.
- `PENABLE` is asserted exactly one cycle after `PSEL` is first asserted for
  a given transaction, and deasserted once the transaction completes.

### 2.4 Error reporting

`PSLVERR` is an optional signal. A slave that never generates errors may tie
it permanently low. Where implemented, whether and when to assert it (e.g.
illegal address, write to read-only location) is entirely a design decision
— not mandated by the protocol itself.

## 3. DUT-Specific Behavior — `apb_slave.sv` (iammituraj/apb)

This section documents this specific DUT's behavior, as described in its
RTL header comments and port list. This is implementation-specific — a
different APB slave could legitimately differ in every point below while
remaining fully APB-compliant.

### 3.1 Source and attribution

- Repository: `iammituraj/apb` (https://github.com/iammituraj/apb)
- File: `apb_slave.sv`
- Author: Mitu Raj, chip@chipmunklogic.com
- License: per repository README — open-source, free to use/modify/distribute

### 3.2 Configuration

- `DW` (data width): 32 bits (default parameter)
- `AW` (address width): 5 bits (default parameter)
- `SW` (strobe width): derived, `DW/8` = 4

### 3.3 Non-APB interface signals

- `o_hw_ctl` (output): directly reflects the value of register 0x00. Not
  part of the APB protocol — an external hardware control path specific to
  this DUT.
- `i_hw_sts` (input): external status input, directly mirrored by register
  0x10 on read (see 3.4). Not part of the APB protocol.

### 3.4 Register address map

| Address | Access | Behavior |
|---------|--------|----------|
| 0x00 | RW | General read-write register. Value also driven out on `o_hw_ctl`. |
| 0x04 | WO | Write-only register. Reads return 0. |
| 0x08 | RW | General read-write register. |
| 0x0C | RO | Constant, hardwired to `0xDEAD_BEEF`. Not affected by reset behavior of other registers. |
| 0x10 | RO | Reflects `i_hw_sts` (external input) directly — not stored, always live. |
| other | — | Reads as 0. Writes have no effect (except error flagging, see 3.6). |

### 3.5 Timing

- **Write access**: 0 wait states. Completes in a single ACCESS cycle
  (`PREADY` asserted immediately when `PENABLE` is seen).
- **Read access**: 1 wait state. Completes on the second ACCESS cycle.

### 3.6 Error conditions (`PSLVERR`)

- Asserted on a **write** to a read-only address (0x0C or 0x10).
- Asserted on a **read** from the write-only address (0x04).
- Not asserted for any other condition (e.g. out-of-range addresses do not
  trigger `PSLVERR` — they simply read as 0 / ignore writes).

### 3.7 Reset behavior

On `PRESETn` low: FSM returns to IDLE, registers 0x00/0x04/0x08 clear to 0,
`PRDATA` clears to 0, `PREADY` and `PSLVERR` deassert. Register 0x0C is a
constant regardless of reset. Register 0x10 always reflects live `i_hw_sts`
regardless of reset.

## 4. Open questions / assumptions to confirm before verification planning

- Back-to-back transactions (new SETUP immediately following a completed
  ACCESS, no idle cycle between): legal per generic APB rules (2.2).
  Covered explicitly — see verification_plan.md IF-4, coverage_model.md
  `cp_back_to_back`.
- `PSEL` deasserting mid-transaction (illegal master behavior): this spec
  does not mandate a required DUT response — the AMBA APB document doesn't
  constrain slave behavior under an illegal master condition. Resolved as:
  verification will observe and document actual behavior, then treat that
  as the DUT's committed contract going forward, since design intent may
  not have considered this case. See verification_plan.md AR-7.
