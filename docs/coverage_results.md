# Coverage Results

**Functional coverage: 100%** (5 covergroups, 14 coverpoints/crosses, 49/49 bins)

Collected with Questa (`-cover bcst`, covergroups reported with `coverage report -cvg -details`) on an APB slave DUT, using constrained-random stimulus plus directed tests.

| Covergroup | Bins hit | What it proves |
|---|---|---|
| `cg_transaction` | 6/6 | Reads and writes both occur, with fast and slow response timing. Reads always saw wait states and writes never did, and the illegal combinations never occurred. |
| `cg_address` | 20/20 | Every register (0x00 to 0x10) and an unmapped address was accessed in both directions: 6 targets x 2 directions, 12 cross bins. |
| `cg_errors` | 15/15 | Error behaviour is exercised and checked: writes to read-only registers and reads from write-only registers all flagged an error, and legal accesses did not. |
| `cg_robustness` | 4/4 | Corner cases: write strobes of zero, partial and full, plus a PSEL deassertion mid-transfer (abort). |
| `cg_hw_interface` | 4/4 | The hardware-side control and status signals were seen toggling in both directions. |

## Reading the report

- **`ZERO` on `read_but_fast` and `write_but_slow` is intentional.** These are `illegal_bin`s: combinations that must never happen. A hit count of zero means the DUT never violated that rule. They are not coverage holes.
- **Why 100% is not the whole story.** Coverage only measures what the bins describe. The bins show the scenarios were exercised; the scoreboard and checks show the DUT behaved correctly during them.
- **Hit counts change between runs** because each run uses a new random seed (logged in `sim/logs/seeds.txt`). The bin totals and the 100% do not.
- **Thin spots worth knowing about:** `zero` and `partial` write strobes were each hit only once, in contrast to 220 for `full`, and the PSEL abort was hit once. They are covered, but only by directed tests, not by random traffic.

## Full reports

- [Summary](../reports/coverage_summary.txt): headline totals
- [Per-bin detail](../reports/coverage_detail.txt): every coverpoint, cross and bin with hit counts
