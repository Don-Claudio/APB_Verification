#!/usr/bin/env bash
set -e

echo "Linting rtl/..."
verible-verilog-lint ../rtl/*.sv --waiver_files=../scripts/verible_waivers.txt

echo "Linting tb/..."
verible-verilog-lint ../tb/*.sv

echo "Lint passed."
