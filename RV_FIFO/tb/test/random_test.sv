class rv_random_test extends rv_base_test;
  `uvm_component_utils(rv_random_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    //set sequence
    rv_seq seq;
    seq = rv_seq::type_id::create("seq", this);
    void'(seq.randomize());  
    env.scb.n_times = seq.n_times;
    //set out_rdy to random mode
    uvm_config_db#(sink_mode_e)::set(this, "env.agt_out.drv_sink", "sink_mode", SINK_RANDOM);
    
    phase.raise_objection(this);
    seq.start(env.agt_in.sqr);
    wait(env.scb.sink_done.triggered);
    phase.drop_objection(this);
    
  endtask
  
  
endclass