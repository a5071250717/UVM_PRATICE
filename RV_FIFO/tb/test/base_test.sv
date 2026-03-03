class rv_base_test extends uvm_test;
  `uvm_component_utils(rv_base_test)
  rv_env env;
  RV_VIF vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = rv_env::type_id::create("env", this);
    if(!uvm_config_db#(RV_VIF)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF","no vif")
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction      
endclass