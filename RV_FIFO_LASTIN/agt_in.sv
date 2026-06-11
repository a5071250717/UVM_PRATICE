class rv_agt_in extends uvm_agent;
  `uvm_component_utils(rv_agt_in)
  rv_drv_source drv_source;
  rv_sqr sqr;
  rv_mon_in mon_in;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_source = rv_drv_source::type_id::create("drv_source", this);  
    sqr = rv_sqr::type_id::create("sqr", this);
    mon_in = rv_mon_in::type_id::create("mon_in", this);      
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv_source.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass