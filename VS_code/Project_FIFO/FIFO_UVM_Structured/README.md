# FIFO UVM Verification Environment


## Questa 10.6c compatibility

QuestaSim 10.6c does not recognize the later `vsim -uvm-debug` option. The Makefile therefore leaves `UVM_DEBUG_FLAGS` empty by default. Run the regression with:

```bash
make clean
make regress UVM_MODE=builtin UVM_HOME="F:/IEEE_Digital/Installation/questasim64_10.6c/verilog_src/uvm-1.1d"
```

Do not add `-uvm-debug` on this simulator version. The optional debug flag remains overridable for newer installations.

This project is the original FIFO UVM environment reorganized into a reusable,
multiple-test structure. The four stimulus scenarios that were previously run
inside one `FIFO_test` class are now four independent UVM tests.

## Directory Structure

```text
FIFO_UVM_Structured/
├── rtl/                    # DUT source, compiled separately
├── tb/                     # Interface and static testbench top
├── pkg/                    # Shared parameters and common definitions
├── env/
│   ├── agent/              # Item, config, sequencer, driver, monitor and agent
│   ├── FIFO_env.sv
│   ├── FIFO_scoreboard.sv
│   └── FIFO_coverage_collector.sv
├── sequences/              # Reusable FIFO sequences
├── tests/                  # Base test plus four derived tests
├── assertions/             # Bound SVA checker
├── harness_files.list      # Shared package/interface compiled before DUT
├── src_files.list          # Remaining verification sources; no RTL
└── Makefile                # Compile, run, regression, waves and coverage
```

## Tests

| Test class | Scenario |
|---|---|
| `fifo_write_only_test` | Write enabled frequently; reads disabled |
| `fifo_read_only_test` | Read enabled frequently; writes disabled |
| `fifo_read_heavy_test` | Randomized traffic biased toward reads |
| `fifo_write_heavy_test` | Randomized traffic biased toward writes |

Every test extends `FIFO_base_test`, which creates and configures the same
reusable environment and applies a deterministic reset before starting the
scenario-specific sequence.

## Questa Setup

Set `QUESTA_UVM_HOME` to the directory containing:

```text
src/questa_uvm_pkg.sv
src/uvm_macros.svh
```

Example:

```bash
export QUESTA_UVM_HOME=/tools/questa/uvm-1.2
```

The Makefile compiles `questa_uvm_pkg.sv` as a separate first stage, following
the requested Questa/UVM debug flow. Set `COMPILE_QUESTA_UVM_PKG=0` when your
installation does not require this package.

## Compilation

```bash
make compile
```

The compilation order is:

1. Create the `work` library.
2. Compile the Questa UVM debug package.
3. Compile optional external VIP packages.
4. Compile `harness_files.list` (shared package and interface required by the DUT).
5. Compile `DUT_SRCS` separately.
6. Compile the remaining verification environment using `src_files.list`.

Both file lists intentionally exclude the DUT. The separate pre-DUT harness list
is needed because this FIFO RTL imports `shared_pkg` and declares an interface
modport in its module port. Another RTL implementation can still be selected
without editing either file list.

## Running Individual Tests

```bash
make run TEST=fifo_write_only_test SEED=1
make run TEST=fifo_read_only_test SEED=2
make run TEST=fifo_read_heavy_test SEED=3
make run TEST=fifo_write_heavy_test SEED=4
```

Enable waveform recording with:

```bash
make run TEST=fifo_write_heavy_test SEED=10 WAVES=1
```

Open a GUI run with:

```bash
make gui TEST=fifo_read_heavy_test SEED=7
```

## Regression and Coverage

```bash
make regress REGRESSION_SEEDS=5
make cov
```

The regression runs every class in `REGRESSION_TESTS` for each seed, saves one
UCDB database per run, and merges the databases. `make cov` writes the final
text report to `coverage_report.txt`.

## Overriding Paths and Tools

Variables can be overridden directly on the make command line:

```bash
make compile \
  DUT_SRCS="../rtl/FIFO_buggy.sv" \
  SRC_LIST="./src_files.list" \
  HARNESS_LIST="./harness_files.list" \
  QUESTA_UVM_HOME="/tools/questa/uvm-1.2"
```

External VIP can be compiled in its own stage:

```bash
make compile \
  VIP_SRCS="../abc_pkg/src/abc_pkg.sv ../xyz_pkg/src/xyz_pkg.sv" \
  VIP_INCDIRS="../abc_pkg/src ../xyz_pkg/src"
```

Other useful overrides include:

```bash
make run VLOG=/custom/bin/vlog VSIM=/custom/bin/vsim
make run UVM_DEBUG_FLAGS=-uvmcontrol=all
make regress REGRESSION_TESTS="fifo_write_only_test fifo_write_heavy_test"
```

## Useful Targets

```bash
make help
make list-tests
make compile
make run TEST=<class> SEED=<n>
make run-only TEST=<class> SEED=<n>
make gui TEST=<class> SEED=<n>
make regress REGRESSION_SEEDS=<n>
make cov
make clean
```

---

## Questa 10.6c UVM Version Selection

Questa 10.6c normally exposes a precompiled `mtiUvm` package identified as
UVM 1.1d. The `uvm_macros.svh` file used to compile the testbench must come
from the same UVM version. Mixing the built-in 1.1d package with the UVM 1.2
macro file produces errors such as:

```text
Number of actuals and formals does not match in function call
```

The later missing-package errors are only cascaded failures after the first
package fails to compile.

### Recommended: use the built-in UVM 1.1d package

```bash
make clean
make compile \
  UVM_MODE=builtin \
  UVM_HOME="F:/IEEE_Digital/Installation/questasim64_10.6c/verilog_src/uvm-1.1d"
```

Use forward slashes under Git Bash. Confirm the folder contains:

```text
src/uvm_macros.svh
```

### Alternative: compile UVM 1.2 from source

```bash
make clean
make compile \
  UVM_MODE=source \
  UVM_HOME="F:/IEEE_Digital/Installation/questasim64_10.6c/verilog_src/uvm-1.2"
```

This compiles `uvm_pkg.sv` into a project-local `uvm_src` library and then
uses the same UVM 1.2 source tree for the macros. `UVM_NO_DPI` is enabled by
default for portability with older Questa installations; override with
`UVM_SOURCE_NO_DPI=0` when a compatible UVM DPI library is configured.

To see the active configuration:

```bash
make uvm-info UVM_MODE=builtin UVM_HOME="F:/.../uvm-1.1d"
```

## Windows / Git Bash coverage-path note

The Makefile uses **relative paths inside Questa Tcl commands** for UCDB, WLF,
and transcript files. This avoids the common Questa-on-Windows failure where a
Git Bash/MSYS path such as `/f/project/build/coverage/file.ucdb` is passed
inside `-do` and Questa cannot open it.

The output folder can be changed while preserving this behavior:

```bash
make regress UVM_MODE=builtin BUILD_SUBDIR=out
```

This stores regression artifacts under `out/coverage`, `out/logs`, and
`out/waves`.
