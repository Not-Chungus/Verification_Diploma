# FIFO UVM — Exact Questa Flow

The Makefile directly implements the supplied Questa flow. There is no `run.do`.

## Commands

```bash
make compile
```

Equivalent compile command:

```bash
vlib work
vlog -sv -f src_files.list +cover -covercells
```

Run one test in the Questa GUI:

```bash
make run TEST=fifo_write_only_test SEED=1
```

The run uses:

```bash
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
coverage save work.ucdb -onexit
do wave.do
run -all
```

Run all four tests over three seeds:

```bash
make regress SEEDS=3
```

Generate the coverage report:

```bash
make cov
```

Equivalent coverage command:

```bash
vcover report work.ucdb -details -all -output code_cvr.txt
```

Clean generated files:

```bash
make clean
```

## Assumptions

- `vlib`, `vlog`, `vsim`, and `vcover` are available in `PATH`.
- QuestaSim 10.6c uses its built-in `mtiUvm` UVM 1.1d library.
- The UVM macro include path in `src_files.list` matches the current installation:
  `F:/IEEE_Digital/Installation/questasim64_10.6c/verilog_src/uvm-1.1d/src`.
- `wave.do` uses the actual interface instance name `top.F_if`; the commented example used `top.FIFO_if`.
- `make run` opens the GUI and writes `work.ucdb` when the simulator exits.
- `make regress` runs in command-line mode, saves one UCDB per test/seed, and merges them into `work.ucdb`.
