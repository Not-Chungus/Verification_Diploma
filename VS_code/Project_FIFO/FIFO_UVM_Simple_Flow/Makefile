TEST  ?= fifo_write_only_test
SEED  ?= 1
SEEDS ?= 3

TESTS = fifo_write_only_test \
        fifo_read_only_test \
        fifo_read_heavy_test \
        fifo_write_heavy_test

.PHONY: compile run regress cov clean

compile:
	rm -rf work
	vlib work
	vlog -sv -f src_files.list +cover -covercells

run: compile
	mkdir -p coverage logs
	vsim -c -voptargs=+acc work.top \
		-classdebug -uvmcontrol=all -cover \
		+UVM_TESTNAME=$(TEST) -sv_seed $(SEED) \
		-l logs/$(TEST)_$(SEED).log \
		-do "run -all; coverage save coverage/cov_$(TEST)_$(SEED).ucdb; quit -f"

regress: compile
	mkdir -p coverage logs
	@for test in $(TESTS); do \
		seed=1; \
		while [ $$seed -le $(SEEDS) ]; do \
			echo "Running $$test with seed $$seed"; \
			vsim -c -voptargs=+acc work.top \
				-classdebug -uvmcontrol=all -cover \
				+UVM_TESTNAME=$$test -sv_seed $$seed \
				-l logs/$${test}_$${seed}.log \
				-do "run -all; coverage save coverage/cov_$${test}_$${seed}.ucdb; quit -f" \
				|| exit $$?; \
			seed=$$((seed + 1)); \
		done; \
	done

cov:
	vcover merge -out work.ucdb coverage/cov_*.ucdb
	vcover report work.ucdb -details -all -output code_cvr.txt

clean:
	rm -rf work coverage logs transcript vsim.wlf work.ucdb code_cvr.txt