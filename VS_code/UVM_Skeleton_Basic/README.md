-No wrapper if the design is in .v

-Recommended order to adjust enviroment:

    shared_package.sv

    FIFO_seq_item.sv
    FIFO_sequencer.sv
    FIFO_sequences.sv
    FIFO_cfg.sv
    FIFO_monitor.sv
    FIFO_drv.sv
    FIFO_agent.sv
    FIFO_coverage_collector.sv
    FIFO_scoreboard.sv
    FIFO_env.sv
    FIFO_test.sv

    top.sv




















-src_files.list may need some tweaking for your system's configuration