class rv_mon_in extends uvm_monitor;
  `uvm_component_utils(rv_mon_in)
  uvm_analysis_port#(u_64t) ap;
  RV_VIF_MON vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(RV_VIF_MON)::get(this, "", "vif_mon", vif))
      `uvm_fatal("MON_IN", "Did not set vif");
    ap = new("ap", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    @(posedge vif.rstn);
    @(vif.cb_mon);
    
    forever begin
      u_64t data_in;
      @(vif.cb_mon);
      data_in = vif.cb_mon.data_in & mask(DATA_W);
      if(vif.cb_mon.in_vld & vif.cb_mon.in_rdy)begin
      	`uvm_info("MON_IN", $sformatf("get %0h", data_in), UVM_LOW); 
        ap.write(data_in);
      end
    end
  endtask
endclass