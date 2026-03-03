class rv_txn extends uvm_sequence_item;
  `uvm_object_utils(rv_txn)
  rand int unsigned gap;
  rand int unsigned data;
  constraint c_gap { gap inside {[0:5]}; }
  function new(string name = "rv_txn");
    super.new(name);
  endfunction
endclass