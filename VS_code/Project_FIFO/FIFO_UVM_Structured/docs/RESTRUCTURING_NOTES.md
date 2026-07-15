# Restructuring Notes

The original project contained all four scenario sequences inside one
`FIFO_test` class. The restructured version introduces:

- `FIFO_base_test`, responsible for environment creation, interface
  configuration, reset, objections and common execution behavior.
- Four derived tests, one for each original scenario.
- `run_test()` without a hardcoded class name in `tb_top`.
- `+UVM_TESTNAME` selection from the Makefile.
- Staged Questa compilation and overridable tool/source paths.
- A verification-only `src_files.list`; the DUT is compiled through `DUT_SRCS`.

The original DUT, agent, scoreboard, coverage collector and assertion behavior
was otherwise preserved. The reset sequence was made deterministic by asserting
reset for two driven cycles and explicitly deasserting it before each test.

- A small `harness_files.list` is compiled before the DUT because the original
  FIFO RTL directly imports `shared_pkg` and uses `FIFO_if.DUT` in its port list.
