class rv_mon_out extends uvm_monitor;
  `uvm_component_utils(rv_mon_out)
  uvm_analysis_port#(u_64t) ap;
  uvm_analysis_port#(rv_txn_sub) ap_sub;
  RV_VIF_MON vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(RV_VIF_MON)::get(this, "", "vif_mon", vif))
      `uvm_fatal("MON_IN", "Did not set vif");
    ap = new("ap", this);
    ap_sub = new("ap_sub", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    @(posedge vif.rstn);
    @(vif.cb_mon);
    forever begin
      rv_txn_sub t;
      u_64t data_out;
      t = rv_txn_sub::type_id::create("t");
      
      @(vif.cb_mon);
      //to subsciber
      t.out_vld = vif.cb_mon.out_vld;
      t.out_rdy = vif.cb_mon.out_rdy;
      ap_sub.write(t);
      //to scoreboard
      if(vif.cb_mon.out_vld & vif.cb_mon.out_rdy)begin
        data_out = vif.cb_mon.data_out & mask(DATA_W);
        `uvm_info("MON_OUT", $sformatf("get %0h", vif.cb_mon.data_out & mask(DATA_W)), UVM_LOW); 
        ap.write(data_out);
      end
    end
  endtask
endclass