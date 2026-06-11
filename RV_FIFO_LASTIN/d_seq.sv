class rv_d_seq extends uvm_sequence#(rv_txn);
  `uvm_object_utils(rv_d_seq)
  int unsigned n_times;
  int unsigned cnt = 0;
  int unsigned deterministic;
  
  function new(string name = "rv_d_seq");
    super.new(name);
  endfunction
  
  task body();
    rv_txn t;
    `uvm_info("SEQ", $sformatf("run %0d times", n_times), UVM_LOW);
    for (int i=1; i<= n_times; i++) begin      
      `uvm_create(t);
      if (deterministic == 1) // data = 1, 2, 3..n in a row
        void'(t.randomize() with {gap == 0; data == i;});
      else // random datam, gap
        void'(t.randomize());
      cnt ++;
      `uvm_info("SEQ", $sformatf("====%0d====", cnt), UVM_LOW);
      `uvm_send(t);
    end
  endtask  
endclass