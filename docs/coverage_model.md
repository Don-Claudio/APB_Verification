# APB Coverage Model

Maps every feature in `docs/verification_plan.md` to a concrete coverage
construct. Same structure as the FIFO project: one covergroup per related
feature cluster, sampled from the monitor (not the driver — coverage
reflects what actually happened on the bus, not what was requested).

## cg_transaction — basic transaction shape (covers IF-1, IF-3, IF-5, AR-1, AR-2)

Sampled once per completed transaction.

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_direction` | `READ`, `WRITE` | IF-5 |
| `cp_wait_states` | `ZERO` (write, 2-cycle), `ONE` (read, 3-cycle) | AR-1, AR-2 |
| `cp_pready_extended` | did `PREADY` stay low ≥1 cycle before completing | IF-3 |
| `cp_back_to_back` | new SETUP begins the cycle immediately following a completed ACCESS, no idle gap | IF-4 |
| `cp_mid_cycle_reset` | `PRESETn` observed asserted at a non-edge-aligned instant (confirms correct synchronous sampling, not distinct per-instant behavior — see verification_plan.md IF-6) | IF-6 |
| `cp_mid_txn_reset` | `PRESETn` observed asserted between SETUP and completion of an in-flight transaction | IF-7 |

Cross: `cp_direction × cp_wait_states` — confirms writes are always
zero-wait and reads are always one-wait, per this DUT's documented timing
(catches a regression if that relationship ever breaks).

Explicit bin, not left to chance: `cp_back_to_back` needs to be hit
deliberately (directed test or a generator biased toward zero idle cycles
between transactions), not just hoped for from generic random stimulus —
same reasoning as `dist` weighting in FIFO, an under-weighted case won't
reliably show up in a reasonable transaction count otherwise.
`cp_mid_cycle_reset` and `cp_mid_txn_reset` are directed tests by nature —
same treatment as FIFO's mid-cycle/mid-transfer reset tests, not something
constrained-random stimulus would ever produce on its own, since reset
timing isn't part of normal transaction generation.

## cg_address — register map coverage (covers FN-1 through FN-9)

Sampled once per completed transaction.

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_addr` | `REG_00`, `REG_04`, `REG_08`, `REG_0C`, `REG_10`, `UNMAPPED` (range bin, not enumerated individually) | FN-1–FN-8 |
| `cp_addr_x_direction` (cross) | every address × {READ, WRITE} | FN-1–FN-9 |

The `UNMAPPED` bin must be a `[low:high]` range covering the rest of the
address space, not left as an implicit catch-all — same lesson as FIFO's
`dist` constraint note: naming specific bins makes everything else illegal
unless explicitly ranged.

## cg_hw_interface — external control/status path (covers FN-6, FN-7)

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_hw_ctl_toggle` | `o_hw_ctl` observed both 0→1 and 1→0 after a 0x00 write | FN-7 |
| `cp_hw_sts_value` | `i_hw_sts` observed both 0 and 1 at the moment 0x10 is read | FN-6 |

## cg_errors — PSLVERR conditions (covers FN-10, FN-11, FN-12, AR-3, AR-4, AR-5)

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_err_cause` | `WR_TO_RO` (0x0C), `WR_TO_ROPLUS` (0x10), `RD_FROM_WO` (0x04), `NONE` | FN-10, FN-11, FN-12 |
| `cp_err_timing` | error asserted exactly 1 cycle after triggering condition (AR-3) | AR-3 |

AR-4/AR-5 (the wr_err/rd_err evaluation-point asymmetry) aren't separately
covered here — they're structural facts about *when* the DUT evaluates the
condition, not independently observable bus-level outcomes distinct from
`cp_err_cause`. They're exercised implicitly by hitting every `cp_err_cause`
bin, but call this out explicitly as a judgment call, not an oversight —
worth confirming this reasoning holds once the testbench actually exists.

## cg_robustness — directed/characterization items (covers AR-6, AR-7)

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_pstrb_pattern` | full-mask write, partial-mask write, zero-mask write — all expected to behave identically | AR-6 |
| `cp_psel_abort` | `PSEL` deasserted before `PENABLE` observed at least once | AR-7 |

`cp_psel_abort` is not lower priority than functional coverage — the design
spec is silent on required behavior here, which is exactly the kind of gap
verification exists to expose rather than skip. Treated as a directed test
with its own explicit pass/fail expectation (documented once observed
behavior is known, in `docs/coverage_results.md` at that milestone), not
just "run it and see." `cp_pstrb_pattern` remains a lighter-weight
characterization check, since AR-6 confirms an already-known non-behavior
(strobe is unused) rather than an open question.

## Removed: "Open item" section

Resolved above — back-to-back transactions now has an explicit coverpoint
(`cp_back_to_back` in `cg_transaction`), and `cp_psel_abort` is elevated
from characterization-only to a first-class, deliberately-tested scenario.
