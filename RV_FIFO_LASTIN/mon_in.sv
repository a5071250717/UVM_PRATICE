class rv_mon_in extends uvm_monitor;
  `uvm_component_utils(rv_mon_in)
  uvm_analysis_port#(fifo_entry_t) ap;
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
      fifo_entry_t t_in;
      @(vif.cb_mon);
      if(vif.cb_mon.in_vld & vif.cb_mon.in_rdy)begin
        t_in.data = vif.cb_mon.data_in & mask(DATA_W);
        t_in.last = vif.cb_mon.last_in;
        `uvm_info("MON_IN", $sformatf("get %0h, %0d", t_in.data, t_in.last), UVM_LOW); 
        ap.write(t_in);
      end
    end
  endtask
endclass