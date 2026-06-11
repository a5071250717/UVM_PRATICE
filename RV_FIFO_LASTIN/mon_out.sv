class rv_mon_out extends uvm_monitor;
  `uvm_component_utils(rv_mon_out)
  uvm_analysis_port#(fifo_entry_t) ap;
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
      fifo_entry_t t_out;
      t = rv_txn_sub::type_id::create("t");
      
      @(vif.cb_mon);
      //to subsciber
      t.out_vld = vif.cb_mon.out_vld;
      t.out_rdy = vif.cb_mon.out_rdy;
      t.last = vif.cb_mon.last_out;
      ap_sub.write(t);
      //to scoreboard
      if(vif.cb_mon.out_vld & vif.cb_mon.out_rdy)begin
        t_out.data = vif.cb_mon.data_out & mask(DATA_W);
        t_out.last = vif.cb_mon.last_out;
        `uvm_info("MON_OUT", $sformatf("get %0h, %0d", t_out.data, t_out.last), UVM_LOW); 
        ap.write(t_out);
      end
    end
  endtask
endclass