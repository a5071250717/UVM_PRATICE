class rv_env extends uvm_env;
  `uvm_component_utils(rv_env)
  rv_agt_in agt_in;
  rv_agt_out agt_out;
  rv_scb scb;
  rv_sub sub;
  //rv_subscriber subscriber;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt_in = rv_agt_in::type_id::create("agt_in", this);
    agt_out = rv_agt_out::type_id::create("agt_out", this);
    scb = rv_scb::type_id::create("scb", this);
    sub = rv_sub::type_id::create("sub", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agt_in.mon_in.ap.connect(scb.fifo_in.analysis_export);
    agt_out.mon_out.ap.connect(scb.fifo_out.analysis_export);    
    agt_out.mon_out.ap_sub.connect(sub.analysis_export);
  endfunction
  

  
endclass