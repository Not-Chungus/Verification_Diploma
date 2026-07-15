class FIFO_main_seq_2 extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_main_seq_2)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_main_seq_2");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");

    repeat (100) begin
      start_item(seq_item);
      seq_item.RD_EN_ON_DIST = 30;
      seq_item.WR_EN_ON_DIST = 70;
      assert(seq_item.randomize());
      finish_item(seq_item);
    end
  endtask
endclass
