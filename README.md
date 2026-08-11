# APB Verification Project

Verification of an AMBA APB (Advanced Peripheral Bus) slave peripheral,
following the public APB protocol specification.

This is the second project in a structured sequence of bus-protocol
verification projects (FIFO → **APB** → AXI4-Lite → AXI4-Stream).

## Status

🚧 In progress — documentation phase (spec / verification plan / coverage model)
being written before any RTL or testbench code.

## Repo structure

- `docs/` — design spec, verification plan, coverage model (written first)
- `rtl/` — DUT source (sourced from an open-source repo, attributed below once selected)
- `tb/` — SystemVerilog testbench
- `sim/` — simulation run scripts (QuestaSim, run locally)
- `scripts/` — lint / utility scripts

## DUT attribution

DUT: `apb_slave.sv` — a single-wait-state-on-read APB slave implementing a
5-register address map with one external hardware control/status pair.

Source: https://github.com/iammituraj/apb
Author: Mitu Raj (chip@chipmunklogic.com)
License: per repository README — open-source, free to use/modify/distribute.

Pulled in unmodified. Design spec (`docs/spec.md`) was written independently
and black-box from the DUT's documented interface/register map, not by
reading its FSM implementation line by line (see spec.md §1 for the one
documented exception, consistent with the FIFO project's precedent).

## CI

GitHub Actions runs lint and basic RTL sanity checks. Full class-based
SystemVerilog UVM/testbench simulation requires a commercial simulator
(QuestaSim) and cannot run in free CI — simulation runs happen locally.
