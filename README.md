# APB Verification Project

Verification of an AMBA APB slave peripheral against a written spec, verification plan and coverage model. Second project in a sequence practicing industry-style verification methodology (spec, verification plan, coverage model, testbench), using both directed and constrained-random stimulus.

## Status

* Design specification
* Verification plan (interface-based / function-based / architecture-based features, per Haque's method as referenced in Bergeron Ch.3)
* Coverage model
* Testbench (interface, transaction, generator, driver, monitor, scoreboard, environment, test, top-level)
* Directed tests: write/read streak, mid-cycle reset, mid-transaction reset, PSEL abort, PSTRB no-effect
* Constrained-random stimulus, weighted toward valid register addresses
* Functional coverage: five covergroups, 100%
* Lint (Verible), clean

## What this verifies

An APB4-shaped slave with five registers (RW, WO, RW, RO constant, RO live-hardware), zero wait states on write, one on read, `PSLVERR` on illegal accesses, and an external hardware control/status pin pair. Covers per-register behavior, error responses, reset behavior, and cases the design spec leaves undefined, such as the master dropping `PSEL` mid-transaction. Known gaps are listed in `docs/coverage_model.md`.

## DUT attribution

The RTL in `rtl/apb_slave.sv` is from https://github.com/iammituraj/apb (Mitu Raj, chip@chipmunklogic.com), open-source and used unmodified. The spec, plan and testbench were written independently against the DUT's documented behavior.

## Structure

```
docs/     specification, verification plan, coverage model, coverage results
rtl/      the DUT
tb/       testbench (interface, classes, top-level module)
sim/      QuestaSim run script
scripts/  lint script, Verible waiver file
```

## Running the simulation

Requires QuestaSim (tested on 2021.1). From `sim/`:

```
vsim -do run.do
```

Compiles the DUT and testbench, runs the directed tests followed by 200 constrained-random transactions, and prints a functional coverage report. The seed is printed as `Sv_Seed`; replay a run with `-sv_seed <value>`.

## Linting

Requires [Verible](https://github.com/chipsalliance/verible). From `sim/`:

```
bash ../scripts/lint.sh
```

The DUT is sourced code left unmodified, so its findings are waived in `scripts/verible_waivers.txt`.

## Results

* Scoreboard: 0 mismatches.
* Functional coverage: 100% across all five covergroups. Latest snapshot in `docs/coverage_results.md`.

## Documentation

* `docs/spec.md`: generic APB behavior and this DUT's register map
* `docs/verification_plan.md`: features to verify
* `docs/coverage_model.md`: how each plan item is covered, and known gaps
* `docs/coverage_results.md`: coverage snapshot

* CI (GitHub Actions): lint runs automatically on every push

## Continuous Integration

`.github/workflows/lint.yml` runs Verible lint on every push and pull request on a GitHub-hosted runner. It does not run the SystemVerilog simulation: QuestaSim is a licensed commercial tool and isn't available on free runners. Simulation runs locally.
