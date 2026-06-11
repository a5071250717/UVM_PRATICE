class rv_txn extends uvm_sequence_item;
  rand int unsigned gap;
  rand int unsigned data;
  rand int last;
  constraint c_gap { gap inside {[0:5]}; }
  `uvm_object_utils_begin(rv_txn)
  `uvm_field_int(gap, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_int(last, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name = "rv_txn");
    super.new(name);
  endfunction
endclass