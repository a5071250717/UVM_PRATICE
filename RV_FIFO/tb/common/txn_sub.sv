class rv_txn_sub extends uvm_sequence_item;
  `uvm_object_utils(rv_txn_sub)
  bit out_rdy, out_vld;
  function new(string name = "rv_txn_sub");
    super.new(name);
  endfunction
endclass