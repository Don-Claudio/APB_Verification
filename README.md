# APB Verification Project

Verification of an AMBA APB (Advanced Peripheral Bus) slave peripheral,
verified against a written spec, verification plan, and coverage model.
Second project in a structured sequence practicing industry-style
verification methodology, following the FIFO project.

## Status

* Design specification
* Verification plan (interface-based / function-based / architecture-based
  features, per Haque's method as referenced in Bergeron Ch.3)
* Coverage model (mapped to plan items; not yet implemented as covergroups)
* Testbench core (interface, transaction, generator, driver, monitor,
  scoreboard, environment, test, top)
* First clean simulation run (200 constrained-random transactions)
* Directed tests: write/read streak, mid-cycle reset, mid-transaction reset
* Directed test in progress: PSEL-abort mid-transaction (AR-7) — driver
  task written, monitor abort-detection still needed
* Directed test not started: PSTRB-has-no-effect (AR-6)
* Functional coverage (covergroups) — not yet implemented
* Lint (Verible) — clean on all authored `tb/` files, from project start
* CI (GitHub Actions) — not yet added
* End-of-project summary document — not yet written

## What this verifies

An APB4-shaped slave with a 5-register address map (RW, WO, RW, RO
constant, RO+ live-hardware), one wait state on read, zero on write,
`PSLVERR` on illegal accesses, and an external hardware control/status
pair (`o_hw_ctl`/`i_hw_sts`). Covers protocol-level SETUP/ACCESS
sequencing, per-register functional correctness, and architecture-level
edge cases the design spec doesn't explicitly define (illegal-master
`PSEL` drop, reset asserted mid-cycle/mid-transaction) — see
`docs/verification_plan.md` for the full feature list.

## DUT attribution

DUT: `apb_slave.sv`, sourced from https://github.com/iammituraj/apb
(Mitu Raj, chip@chipmunklogic.com), pulled in unmodified with attribution
in the file header and here. Per repository terms: open-source, free to
use/modify/distribute. Verification plan and testbench built independently
against the DUT's documented interface/register map, not by reading its
FSM implementation line by line.

## Structure
