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

TBD — an open-source APB slave will be sourced and attributed here once selected,
per project convention (design spec is written independently and black-box from
the DUT's documented behavior, not by reading its RTL line by line).

## CI

GitHub Actions runs lint and basic RTL sanity checks. Full class-based
SystemVerilog UVM/testbench simulation requires a commercial simulator
(QuestaSim) and cannot run in free CI — simulation runs happen locally.
