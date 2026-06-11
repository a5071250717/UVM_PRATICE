class pkg_seq extends uvm_sequence#(rv_txn);
  `uvm_object_utils(pkg_seq)
  rand bit [2:0] pkg_num;
  rand bit [2:0] pkg_len[];
  constraint c_pkg_num{
    pkg_num inside {[1:4]};
    pkg_len.size() == pkg_num;
  }
  constraint c_pkg_len{
    foreach (pkg_len[i]) 
      pkg_len[i] inside {[2:4]}; 
  }

  function new(string name = "pkg_seq");
    super.new(name);
  endfunction
  
  task body();    
    for(int num=0; num<pkg_num; num++) begin
      for(int len=0; len<pkg_len[num]; len++) begin
        rv_txn t = rv_txn::type_id::create("rv_txn");
        start_item(t);
        void'(t.randomize with {
          last == (len == pkg_len[num] -1);
        });
        finish_item(t);
      end
    end
  endtask
  
endclass