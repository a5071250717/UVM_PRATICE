class rv_d_test_full_to_empty extends rv_base_test;
  `uvm_component_utils(rv_d_test_full_to_empty)
    function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    rv_d_seq seq;
    seq = rv_d_seq::type_id::create("seq");
    // n_times = depth 強迫full, 不可以>DEPTH, 因為drv_source會等待，因此seq.start blocking 
    seq.n_times = DEPTH;
    env.scb.n_times += DEPTH;
    seq.deterministic = 1;
	
    phase.raise_objection(this);
    // 1) 強制out_rdy = 0
    uvm_config_db#(sink_mode_e)::set(this, "env.agt_out.drv_sink", "sink_mode", SINK_ALWAYS_STALL);

    seq.start(env.agt_in.sqr);
    
    // 2) 等待full
    wait(vif.full);
  
    // 3) 強制out_rdy = 1， 讓FIFO把資料吐完
    uvm_config_db#(sink_mode_e)::set(this, "env.agt_out.drv_sink", "sink_mode", SINK_ALWAYS_READY);    
    
    // 4) 等待full
    wait(vif.empty)
    
    // 等待scoreboard 收到所有資料
    wait(env.scb.sink_done.triggered);
    
    phase.drop_objection(this);
  endtask

endclass