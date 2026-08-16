# APB Verification Plan

## 1. Purpose and method

This plan enumerates the features to be verified, organized per Haque's
method (as referenced in Bergeron Ch.3): **interface-based**,
**function-based**, and **architecture-based** features. This mirrors the
FIFO project's approach.

- **Interface-based**: features derivable purely from the protocol/pin-level
  contract — true for any APB slave, independent of this DUT's internals.
- **Function-based**: features derived from what this DUT is documented to
  *do* — its register map, error behavior, hardware interface — treating it
  as a black box.
- **Architecture-based**: features that require knowledge of this DUT's
  internal implementation to verify meaningfully (e.g. exact wait-state
  timing) — the deliberate, documented exception to black-box testing,
  same category as FIFO's pointer-wraparound precedent.

## 2. Interface-based features

Derived from spec.md §2 (generic APB). These checks are DUT-agnostic and
would apply to verifying any APB4-compliant slave.

| ID | Feature | Description |
|----|---------|--------------|
| IF-1 | SETUP→ACCESS sequencing | `PENABLE` asserts exactly one cycle after `PSEL` is first asserted for a transaction, never before, never simultaneously. |
| IF-2 | Signal stability during transaction | `PADDR`, `PWRITE`, `PWDATA`, `PSTRB`, `PSEL` remain stable from SETUP through the end of ACCESS (until `PREADY` is sampled high). |
| IF-3 | PREADY gates completion | Transaction only completes on the cycle `PREADY` is sampled high; deasserted `PREADY` correctly extends ACCESS phase (wait states). |
| IF-4 | Return to IDLE / back-to-back | Bus correctly returns to IDLE after completion, or correctly begins a new SETUP immediately (back-to-back transactions), without violating IF-1/IF-2. |
| IF-5 | Read vs write direction | `PWRITE` correctly selects read/write behavior; `PWDATA` ignored on reads, `PRDATA` ignored (by master) on writes. |
| IF-6 | Mid-cycle reset | `PRESETn` (synchronous reset — sampled at `posedge pclk`, not asynchronous) asserted at an arbitrary point within a clock cycle, ahead of the next edge. This confirms reset is correctly sampled and takes effect at the next edge regardless of exact assertion timing within the cycle — it does not test differing behavior based on *when* within the cycle reset lands, since a synchronous design has no such sensitivity by construction. Value is in confirming stable sampling/setup margin, not in exercising distinct outcomes per assertion instant. |
| IF-7 | Mid-transaction reset | `PRESETn` asserted between SETUP and transaction completion (i.e. mid-ACCESS, before `PREADY` would have gone high) — transaction must be correctly abandoned, no partial register write, FSM returns cleanly to IDLE. |

## 3. Function-based features

Derived from spec.md §3 (this DUT's documented register map and behavior).
Black-box: verified by driving APB transactions and checking documented
outcomes, not by referencing internal FSM state.

| ID | Feature | Description |
|----|---------|--------------|
| FN-1 | RW register 0x00 | Write then read back returns the written value. |
| FN-2 | RW register 0x08 | Write then read back returns the written value. |
| FN-3 | WO register 0x04 write | Write succeeds (no error) for a valid write. |
| FN-4 | WO register 0x04 read | Reading 0x04 returns 0, not the last written value. |
| FN-5 | RO constant register 0x0C | Always reads back `0xDEAD_BEEF`, regardless of prior writes/reset. |
| FN-6 | RO+ live register 0x10 | Read reflects the current value of `i_hw_sts` at the time of the read, not a stored/stale value. |
| FN-7 | o_hw_ctl reflects register 0x00 | Writing register 0x00 causes `o_hw_ctl` to reflect the new value. |
| FN-8 | Unmapped address read | Reading an address outside the 5-register map returns 0. |
| FN-9 | Unmapped address write | Writing an address outside the 5-register map has no effect (no register changes, no error). |
| FN-10 | PSLVERR on write to RO/RO+ | Writing to 0x0C or 0x10 asserts `PSLVERR`, and the register's value is unaffected by the attempted write. |
| FN-11 | PSLVERR on read from WO | Reading 0x04 asserts `PSLVERR`. |
| FN-12 | No PSLVERR on legal access | Legal reads/writes to RW/WO/RO addresses within their allowed direction never assert `PSLVERR`. |
| FN-13 | Reset value of RW/WO registers | Registers 0x00, 0x04, 0x08 read as 0 immediately after reset. |

## 4. Architecture-based features

Requires knowledge of this DUT's internal FSM/timing (documented in the RTL
header and confirmed by our own read-through) to verify precisely. This is
the deliberate exception to black-box testing.

| ID | Feature | Description |
|----|---------|--------------|
| AR-1 | Write timing (0 wait states) | A write transaction completes in exactly 2 cycles (SETUP + 1 ACCESS cycle), `PREADY` high on the first ACCESS cycle. |
| AR-2 | Read timing (1 wait state) | A read transaction completes in exactly 3 cycles (SETUP + 2 ACCESS cycles), `PREADY` low on the first ACCESS cycle, high on the second. |
| AR-3 | PSLVERR registered delay | `PSLVERR` reflects the error condition one cycle after the condition is internally true (it is a registered output, not combinational). |
| AR-4 | Write-error evaluated pre-PENABLE | `wr_err` (feeding `PSLVERR`) is evaluated based on address/`PWRITE` while still in IDLE — i.e. does not require `PENABLE` to have been asserted at all. Worth a directed test to confirm whether an aborted SETUP (PSEL drops before PENABLE) still produces an error. |
| AR-5 | Read-error evaluated during ACCESS | `rd_err` is only evaluated during the ACCESS-phase cycle, unlike AR-4 — confirm this asymmetry doesn't cause a missed or extra error under edge-case timing. |
| AR-6 | PSTRB has no effect | Writes with any `PSTRB` pattern (including all-zero) produce the same result as a full-word write — confirms byte-strobe is accepted but not implemented. |
| AR-7 | PSEL drop mid-transaction | Design spec is silent on required behavior here — a genuine gap, not a non-issue. Elevated to a first-class directed test: observe and document actual DUT behavior, then hold the DUT to that documented behavior going forward (regression-worthy, not just characterization). |

## 5. Resolved decisions

- **PSTRB**: confirmed unused. `i_pstrb` is a port on this DUT but is never
  referenced in the write-data path — writes apply the full word
  unconditionally. This DUT accepts an APB4-shaped interface but does not
  implement byte-lane write masking. No FN feature entries needed for
  partial-word writes; may be worth one directed test (AR-6, added below)
  confirming `PSTRB` truly has no effect, as a documented negative check.
- **PSEL mid-transaction**: treated as a robustness/directed test (AR-7,
  added below), not a spec-compliance check — the APB spec doesn't mandate
  a specific DUT response to an illegal master, but observing and
  documenting actual behavior is still worth verifying.

## 6. Explicitly out of scope

- Multi-slave bus arbitration / multiple `PSEL` lines — not applicable, this
  project verifies a single slave in isolation.
