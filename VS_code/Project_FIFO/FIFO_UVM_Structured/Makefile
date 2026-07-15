# ==============================================================================
# FIFO UVM / Questa Makefile
#
# Supports two UVM compilation modes:
#
#   UVM_MODE=builtin
#     Uses Questa's precompiled UVM package (for Questa 10.6c this is normally
#     mtiUvm / UVM 1.1d). UVM_HOME must point to the MATCHING source tree so
#     uvm_macros.svh comes from the same UVM version as the compiled package.
#
#   UVM_MODE=source
#     Compiles UVM from UVM_HOME/src/uvm_pkg.sv into a project-local library.
#     Use this when you specifically want UVM 1.2 with an older Questa release.
#
# The DUT remains separate from src_files.list and can be overridden at make
# invocation time. All paths and most tool options are overridable.
# ============================================================================== 

SHELL := /bin/bash
.NOTPARALLEL:

# ---------------------------- Project paths -----------------------------------
PROJECT_ROOT       ?= $(abspath .)
SRC_LIST           ?= $(PROJECT_ROOT)/src_files.list
HARNESS_LIST       ?= $(PROJECT_ROOT)/harness_files.list
DUT_SRCS           ?= $(PROJECT_ROOT)/rtl/FIFO.sv
TOP                 ?= tb_top
WORK_LIB            ?= work
# BUILD_SUBDIR is deliberately relative to PROJECT_ROOT.  Questa on Windows can
# consume MSYS paths such as /f/... when they are normal command-line arguments,
# but a path embedded inside a Tcl -do command is not converted.  Therefore the
# simulator-facing paths below remain relative, while shell/vcover paths remain
# absolute.
BUILD_SUBDIR        ?= build
BUILD_DIR           ?= $(PROJECT_ROOT)/$(BUILD_SUBDIR)
LOG_DIR             ?= $(BUILD_DIR)/logs
COV_DIR             ?= $(BUILD_DIR)/coverage
WAVE_DIR            ?= $(BUILD_DIR)/waves
SIM_LOG_DIR         ?= $(BUILD_SUBDIR)/logs
SIM_COV_DIR         ?= $(BUILD_SUBDIR)/coverage
SIM_WAVE_DIR        ?= $(BUILD_SUBDIR)/waves
MERGED_COV          ?= $(COV_DIR)/merged.ucdb
COVERAGE_REPORT     ?= $(PROJECT_ROOT)/coverage_report.txt

# ----------------------------- Questa tools -----------------------------------
VLIB                ?= vlib
VLOG                ?= vlog
VSIM                ?= vsim
VCOVER              ?= vcover

# ------------------------------ UVM setup -------------------------------------
# Recommended for Questa 10.6c:
#   UVM_MODE=builtin
#   UVM_HOME=F:/.../questasim64_10.6c/verilog_src/uvm-1.1d
#
# To use UVM 1.2 from source instead:
#   UVM_MODE=source
#   UVM_HOME=F:/.../questasim64_10.6c/verilog_src/uvm-1.2
UVM_MODE            ?= builtin
UVM_HOME            ?= "F:/IEEE_Digital/Installation/questasim64_10.6c/verilog_src/uvm-1.1d"
UVM_SRC             ?= $(UVM_HOME)/src
UVM_PKG_SRC         ?= $(UVM_SRC)/uvm_pkg.sv

# Built-in mode variables.
UVM_BUILTIN_LIB     ?= mtiUvm

# Source mode variables.
UVM_SOURCE_LIB      ?= uvm_src
UVM_SOURCE_NO_DPI   ?= 1

# Optional Questa UVM debug-integration package. This is separate from uvm_pkg.
# The directory must match the UVM version selected above.
COMPILE_QUESTA_UVM_PKG ?= 0
QUESTA_UVM_DEBUG_HOME   ?=
QUESTA_UVM_DEBUG_SRC    ?= $(QUESTA_UVM_DEBUG_HOME)/src
QUESTA_UVM_PKG          ?= $(QUESTA_UVM_DEBUG_SRC)/questa_uvm_pkg.sv

ifeq ($(UVM_MODE),source)
  ACTIVE_UVM_LIB       := $(UVM_SOURCE_LIB)
  UVM_LIB_FLAGS        := -L $(UVM_SOURCE_LIB)
  ifeq ($(UVM_SOURCE_NO_DPI),1)
    UVM_SOURCE_DEFINES := +define+UVM_NO_DPI
  else
    UVM_SOURCE_DEFINES :=
  endif
else ifeq ($(UVM_MODE),builtin)
  ACTIVE_UVM_LIB       := $(UVM_BUILTIN_LIB)
  UVM_LIB_FLAGS        := -L $(UVM_BUILTIN_LIB)
  UVM_SOURCE_DEFINES   :=
else
  $(error UVM_MODE must be either 'builtin' or 'source')
endif

# Optional external VIP, compiled before the DUT.
VIP_SRCS            ?=
VIP_INCDIRS         ?=
VIP_INC_FLAGS       := $(foreach d,$(VIP_INCDIRS),+incdir+$(d))

# ---------------------------- Test selection ----------------------------------
TEST                 ?= fifo_write_only_test
SEED                 ?= 1
WAVES                ?= 0
COVERAGE             ?= 1
UVM_VERBOSITY        ?= UVM_MEDIUM

REGRESSION_TESTS     ?= \
  fifo_write_only_test \
  fifo_read_only_test \
  fifo_read_heavy_test \
  fifo_write_heavy_test
REGRESSION_SEEDS     ?= 3

# ------------------------------ Tool flags ------------------------------------
VLOG_COMMON_FLAGS    ?= -sv -timescale 1ns/1ps $(UVM_LIB_FLAGS) +acc
DUT_COVER_FLAGS      ?= +cover=bcesft
EXTRA_VLOG_FLAGS     ?=

# Leave empty for maximum compatibility with older Questa versions. Override:
#   make run UVM_DEBUG_FLAGS=-uvm-debug
# or, depending on the installation:
#   make run UVM_DEBUG_FLAGS=-uvmcontrol=all
UVM_DEBUG_FLAGS      ?=
VSIM_COMMON_FLAGS    ?= $(UVM_LIB_FLAGS)
EXTRA_VSIM_ARGS      ?=

ifeq ($(COVERAGE),1)
  VSIM_COVER_FLAGS   := -coverage
  COVERAGE_DO        = coverage save -onexit {$(SIM_COV_DIR)/cov_$(TEST)_$(SEED).ucdb};
else
  VSIM_COVER_FLAGS   :=
  COVERAGE_DO        :=
endif

ifeq ($(WAVES),1)
  WAVE_OPTION        = -wlf "$(SIM_WAVE_DIR)/waves_$(TEST)_$(SEED).wlf"
  WAVE_DO            := log -r /*;
else
  WAVE_OPTION        :=
  WAVE_DO            :=
endif

RUN_LOG              = $(SIM_LOG_DIR)/$(TEST)_seed$(SEED).log

.PHONY: all help uvm-info dirs init check-uvm compile compile-uvm \
        compile-questa-uvm-debug compile-vip compile-harness compile-dut \
        compile-tb run run-only gui regress merge-cov cov list-tests clean

all: run

help:
	@echo "FIFO UVM / Questa targets"
	@echo ""
	@echo "  make compile                         Compile UVM, VIP, DUT and TB"
	@echo "  make run TEST=<test> SEED=<n>        Compile and run one test"
	@echo "  make run-only TEST=<test> SEED=<n>   Run without recompiling"
	@echo "  make gui TEST=<test> SEED=<n>        Run one test in the GUI"
	@echo "  make regress REGRESSION_SEEDS=<n>    Run all tests over several seeds"
	@echo "  make cov                             Merge and report coverage"
	@echo "  make uvm-info                        Print active UVM configuration"
	@echo "  make list-tests                      Print available test names"
	@echo "  make clean                           Remove generated artifacts"
	@echo ""
	@echo "Questa 10.6c built-in UVM example:"
	@echo '  make compile UVM_MODE=builtin UVM_HOME="F:/.../verilog_src/uvm-1.1d"'
	@echo ""
	@echo "UVM 1.2 source example:"
	@echo '  make compile UVM_MODE=source UVM_HOME="F:/.../verilog_src/uvm-1.2"'
	@echo ""
	@echo "Common overrides: DUT_SRCS, SRC_LIST, HARNESS_LIST, VIP_SRCS,"
	@echo "VIP_INCDIRS, BUILD_SUBDIR, WAVES, COVERAGE, UVM_VERBOSITY and EXTRA_VLOG_FLAGS"

uvm-info:
	@echo "UVM_MODE            = $(UVM_MODE)"
	@echo "UVM_HOME            = $(UVM_HOME)"
	@echo "UVM_SRC             = $(UVM_SRC)"
	@echo "ACTIVE_UVM_LIB      = $(ACTIVE_UVM_LIB)"
	@echo "UVM_LIB_FLAGS       = $(UVM_LIB_FLAGS)"
	@echo "UVM_SOURCE_NO_DPI   = $(UVM_SOURCE_NO_DPI)"
	@echo "DEBUG_PACKAGE       = $(COMPILE_QUESTA_UVM_PKG)"

list-tests:
	@for t in $(REGRESSION_TESTS); do echo $$t; done

dirs:
	@mkdir -p "$(BUILD_DIR)" "$(LOG_DIR)" "$(COV_DIR)" "$(WAVE_DIR)"

init: dirs
	@echo "[INIT] Creating Questa work library: $(WORK_LIB)"
	@rm -rf "$(PROJECT_ROOT)/$(WORK_LIB)"
	@cd "$(PROJECT_ROOT)" && $(VLIB) "$(WORK_LIB)"
	@if [[ "$(UVM_MODE)" == "source" ]]; then \
	  echo "[INIT] Creating source UVM library: $(UVM_SOURCE_LIB)"; \
	  rm -rf "$(PROJECT_ROOT)/$(UVM_SOURCE_LIB)"; \
	  cd "$(PROJECT_ROOT)" && $(VLIB) "$(UVM_SOURCE_LIB)"; \
	fi

check-uvm:
	@if [[ -z "$(UVM_HOME)" ]]; then \
	  echo "ERROR: UVM_HOME (or QUESTA_UVM_HOME) is not set."; \
	  exit 2; \
	fi
	@if [[ ! -f "$(UVM_SRC)/uvm_macros.svh" ]]; then \
	  echo "ERROR: Cannot find $(UVM_SRC)/uvm_macros.svh"; \
	  exit 2; \
	fi
	@if [[ "$(UVM_MODE)" == "source" && ! -f "$(UVM_PKG_SRC)" ]]; then \
	  echo "ERROR: Cannot find $(UVM_PKG_SRC)"; \
	  exit 2; \
	fi
	@if [[ "$(COMPILE_QUESTA_UVM_PKG)" == "1" ]]; then \
	  if [[ -z "$(QUESTA_UVM_DEBUG_HOME)" || ! -f "$(QUESTA_UVM_PKG)" ]]; then \
	    echo "ERROR: Cannot find the Questa debug package: $(QUESTA_UVM_PKG)"; \
	    echo "Set QUESTA_UVM_DEBUG_HOME to the matching questa_uvm_pkg-* folder,"; \
	    echo "or set COMPILE_QUESTA_UVM_PKG=0."; \
	    exit 2; \
	  fi; \
	fi

# Dependency chain enforces the requested screenshot-style compile order.
compile: compile-tb
	@echo "[COMPILE] Complete"

compile-uvm: init check-uvm
	@if [[ "$(UVM_MODE)" == "source" ]]; then \
	  echo "[UVM] Compiling $(UVM_PKG_SRC) into $(UVM_SOURCE_LIB)"; \
	  cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(UVM_SOURCE_LIB)" -sv \
	    $(UVM_SOURCE_DEFINES) +incdir+"$(UVM_SRC)" "$(UVM_PKG_SRC)"; \
	else \
	  echo "[UVM] Using precompiled $(UVM_BUILTIN_LIB)"; \
	  echo "[UVM] Macros are taken from $(UVM_SRC)"; \
	  echo "[UVM] IMPORTANT: the macro source version must match the built-in package"; \
	fi

compile-questa-uvm-debug: compile-uvm
	@if [[ "$(COMPILE_QUESTA_UVM_PKG)" == "1" ]]; then \
	  echo "[UVM-DEBUG] Compiling $(QUESTA_UVM_PKG)"; \
	  cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(WORK_LIB)" -sv \
	    $(UVM_LIB_FLAGS) +incdir+"$(UVM_SRC)" \
	    +incdir+"$(QUESTA_UVM_DEBUG_SRC)" "$(QUESTA_UVM_PKG)"; \
	else \
	  echo "[UVM-DEBUG] Skipped (COMPILE_QUESTA_UVM_PKG=0)"; \
	fi

compile-vip: compile-questa-uvm-debug
	@if [[ -n "$(strip $(VIP_SRCS))" ]]; then \
	  echo "[VIP] Compiling external VIP"; \
	  cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(WORK_LIB)" $(VLOG_COMMON_FLAGS) \
	    +incdir+"$(UVM_SRC)" $(VIP_INC_FLAGS) $(VIP_SRCS) $(EXTRA_VLOG_FLAGS); \
	else \
	  echo "[VIP] No external VIP sources supplied"; \
	fi

compile-harness: compile-vip
	@echo "[HARNESS] Compiling pre-DUT dependencies from $(HARNESS_LIST)"
	@cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(WORK_LIB)" $(VLOG_COMMON_FLAGS) \
	  +incdir+"$(UVM_SRC)" -f "$(HARNESS_LIST)" $(EXTRA_VLOG_FLAGS)

compile-dut: compile-harness
	@echo "[DUT] Compiling: $(DUT_SRCS)"
	@cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(WORK_LIB)" $(VLOG_COMMON_FLAGS) \
	  +incdir+"$(UVM_SRC)" $(DUT_COVER_FLAGS) $(DUT_SRCS) $(EXTRA_VLOG_FLAGS)

compile-tb: compile-dut
	@echo "[TB] Compiling verification sources from $(SRC_LIST)"
	@cd "$(PROJECT_ROOT)" && $(VLOG) -work "$(WORK_LIB)" $(VLOG_COMMON_FLAGS) \
	  +incdir+"$(UVM_SRC)" -f "$(SRC_LIST)" $(EXTRA_VLOG_FLAGS)

run: compile run-only

run-only: dirs check-uvm
	@echo "[RUN] TEST=$(TEST) SEED=$(SEED) WAVES=$(WAVES) COVERAGE=$(COVERAGE)"
	@cd "$(PROJECT_ROOT)" && $(VSIM) $(UVM_DEBUG_FLAGS) $(VSIM_COVER_FLAGS) \
	  $(VSIM_COMMON_FLAGS) -c "$(WORK_LIB).$(TOP)" \
	  +UVM_TESTNAME=$(TEST) -sv_seed $(SEED) +SEED=$(SEED) \
	  +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_NO_RELNOTES \
	  $(WAVE_OPTION) -l "$(RUN_LOG)" $(EXTRA_VSIM_ARGS) \
	  -do '$(COVERAGE_DO) $(WAVE_DO) run -all; quit -f'

gui: compile
	@echo "[GUI] TEST=$(TEST) SEED=$(SEED)"
	@cd "$(PROJECT_ROOT)" && $(VSIM) $(UVM_DEBUG_FLAGS) $(VSIM_COVER_FLAGS) \
	  $(VSIM_COMMON_FLAGS) "$(WORK_LIB).$(TOP)" \
	  +UVM_TESTNAME=$(TEST) -sv_seed $(SEED) +SEED=$(SEED) \
	  +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_NO_RELNOTES \
	  -wlf "$(SIM_WAVE_DIR)/waves_$(TEST)_$(SEED).wlf" \
	  -l "$(RUN_LOG)" $(EXTRA_VSIM_ARGS) \
	  -do '$(COVERAGE_DO) log -r /*; add wave -r /*; run -all'

regress: compile
	@echo "[REGRESSION] Tests: $(REGRESSION_TESTS)"
	@echo "[REGRESSION] Seeds per test: $(REGRESSION_SEEDS)"
	@status=0; \
	for test_name in $(REGRESSION_TESTS); do \
	  for seed_value in $$(seq 1 $(REGRESSION_SEEDS)); do \
	    echo "[REGRESSION] $$test_name seed=$$seed_value"; \
	    $(MAKE) --no-print-directory run-only \
	      TEST=$$test_name SEED=$$seed_value WAVES=0 || status=1; \
	  done; \
	done; \
	$(MAKE) --no-print-directory merge-cov || status=1; \
	exit $$status

merge-cov: dirs
	@if [[ "$(COVERAGE)" != "1" ]]; then \
	  echo "[COVERAGE] COVERAGE=0, nothing to merge"; \
	  exit 0; \
	fi
	@shopt -s nullglob; files=("$(COV_DIR)"/cov_*.ucdb); \
	if (( $${#files[@]} == 0 )); then \
	  echo "ERROR: No UCDB files found in $(COV_DIR)"; \
	  exit 2; \
	fi; \
	echo "[COVERAGE] Merging $${#files[@]} databases"; \
	$(VCOVER) merge -out "$(MERGED_COV)" "$${files[@]}"

cov: merge-cov
	@echo "[COVERAGE] Writing $(COVERAGE_REPORT)"
	@$(VCOVER) report -details -all "$(MERGED_COV)" > "$(COVERAGE_REPORT)"
	@echo "[COVERAGE] Report complete"

clean:
	@echo "[CLEAN] Removing generated files"
	@rm -rf "$(PROJECT_ROOT)/$(WORK_LIB)" "$(PROJECT_ROOT)/$(UVM_SOURCE_LIB)" \
	  "$(BUILD_DIR)" "$(PROJECT_ROOT)/transcript" "$(COVERAGE_REPORT)" \
	  "$(PROJECT_ROOT)"/*.wlf "$(PROJECT_ROOT)"/*.ucdb
