class rv_agt_out extends uvm_agent;
  `uvm_component_utils(rv_agt_out)
  rv_drv_sink drv_sink;
  rv_mon_out mon_out;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_sink = rv_drv_sink::type_id::create("drv_sink", this);    
    mon_out = rv_mon_out::type_id::create("mon_out", this);    
  endfunction
  
endclass