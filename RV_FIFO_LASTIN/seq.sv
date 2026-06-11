class rv_seq extends uvm_sequence#(rv_txn);
  `uvm_object_utils(rv_seq)
  rand int unsigned n_times;
  int unsigned cnt = 0;
  int unsigned deterministic;
  constraint c_n_times {n_times inside {[1:10]}; }
  
  
  function new(string name = "rv_seq");
    super.new(name);
  endfunction
  
  task body();
    rv_txn t;
    `uvm_info("SEQ", $sformatf("run %0d times", n_times), UVM_LOW);
    repeat(n_times) begin
      cnt ++;
      `uvm_info("SEQ", $sformatf("====%0d====", cnt), UVM_LOW);
      `uvm_do(t);
    end
  endtask
endclass