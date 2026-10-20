# APB Coverage Model

Maps `docs/verification_plan.md` to functional coverage, and records which plan
items are covered, which are checked another way, and which are not tracked.

All five covergroups live in `tb/apb_monitor.sv` and are sampled once per
completed transaction, after `PREADY` is seen and the response is captured. An
aborted transaction is dropped by the monitor and sampled only by `cg_robustness`.

Coverage shows whether a scenario occurred. The scoreboard judges whether the
DUT's response was correct. Full coverage with a clean scoreboard means every
defined scenario happened and every one that happened was checked.

## Sampling

Class-level monitor members read by the covergroups: `txn`, `reg_idx`,
`wait_cycles`, `aborted`. `reg_idx = paddr[AW-1:2]` matches the DUT's
word-aligned decode, so bins are by register index, not raw address.
`wait_cycles` counts ticks spent waiting for `PREADY` (1 for a write, 2 for a
read on this DUT).

## cg_transaction

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_direction` | read, write | IF-5 |
| `cp_wait_cycles` | fast = 1, slow = 2 | AR-1, AR-2, IF-3 |
| `cx_dir_x_wait` | read×slow, write×fast | AR-1, AR-2 |

`illegal_bins` write×slow and read×fast raise an error if this DUT ever makes a
write wait or a read finish early. Their report line reads `ZERO`, which is the
passing result. They are excluded from the percentage.

## cg_address

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_reg` | reg_00, reg_04, reg_08, reg_0C, reg_10, unmapped = [5:7] | FN-1 to FN-5, FN-8, FN-9 |
| `cp_dir` | read, write | |
| `cx_reg_x_dir` | all 12 combinations | |

No cross exclusions: every combination can occur. Error-path accesses (read of
0x04, write to 0x0C/0x10) are legal stimulus, so they are normal bins.

## cg_hw_interface

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_hw_ctl` | rise (0=>1), fall (1=>0) | FN-7 |
| `cp_hw_sts` | low, high, on reads of 0x10 | FN-6 |

`hw_ctl` mirrors bit 0 of register 0x00, so a reset can also produce a `fall`.

## cg_errors

| Coverpoint | Bins |
|---|---|
| `cp_reg`, `cp_dir` | as above |
| `cp_err` | none, error |
| `cx_err` (named cells only) | wr_to_RO, rd_from_WO, legal_write_clean, legal_read_clean, unmapped_clean |

Plan items: FN-3, FN-4, FN-8 to FN-12. Each cell names the stimulus and the
expected `PSLVERR` response, so a cell only ticks if both occurred.

## cg_robustness

| Coverpoint | Bins | Plan item |
|---|---|---|
| `cp_pstrb_pattern` | full = 1111, zero = 0000, partial = 0001 to 1110, on completed writes | AR-6 |
| `cp_psel_abort` | happened | AR-7 |

This group confirms the directed tests reached the bus. It does not judge the
DUT's response.

## Traceability

| Plan item | Mechanism |
|---|---|
| IF-1, IF-2 | **Not checked** (see gaps) |
| IF-3 | Covered: `cp_wait_cycles.slow` |
| IF-4 | Exercised incidentally by streak and forked tests; no coverpoint |
| IF-5 | Covered: `cp_direction` |
| IF-6, IF-7 | Directed tests plus scoreboard resync on reset; no coverpoint |
| FN-1 to FN-5, FN-8, FN-9 | Scoreboard plus `cx_reg_x_dir` |
| FN-6, FN-7 | Scoreboard plus `cg_hw_interface` |
| FN-10 to FN-12 | Scoreboard plus `cx_err` |
| FN-13 | Scoreboard model resync; no dedicated read-after-reset |
| AR-1, AR-2 | `cx_dir_x_wait` with `illegal_bins` |
| AR-3 to AR-5 | Not covered (see decisions) |
| AR-6, AR-7 | `cg_robustness` |

## Decisions

- **`cp_err_timing` (AR-3) dropped.** `PSLVERR` is registered and sampled with
  `PREADY`, so a late error is seen as 0 by the scoreboard. An early error
  cannot occur from a registered output. This is reasoned, not tested.
- **AR-4 and AR-5 not covered.** They describe when the DUT evaluates the error
  condition internally, which is not separately observable at the bus.
- **Reset bins removed from `cg_transaction`.** Reset is not a per-transaction
  event. The monitor raises `reset_occurred` and the scoreboard resyncs.

## Known gaps

- **IF-1 and IF-2** are master-side protocol rules produced by our own driver.
  Nothing currently checks them. An assertion bound to the interface would.
- **IF-4, IF-6, IF-7** have no coverage bins, only directed tests.
- **FN-13** is exercised only incidentally.
