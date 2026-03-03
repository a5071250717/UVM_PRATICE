class rv_drv_source extends uvm_driver#(rv_txn);
  `uvm_component_utils(rv_drv_source)
  RV_VIF_DRV vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(RV_VIF_DRV)::get(this, "", "vif_drv", vif))
      `uvm_fatal("DRV_SOURCE", "Did not set vif");
  endfunction
  
  task run_phase(uvm_phase phase);
    rv_txn t;
    vif.cb_drv.in_vld <= 0;
    vif.cb_drv.data_in <= 0;
    @(posedge vif.rstn);
    forever begin
      seq_item_port.get_next_item(t);
      @(vif.cb_drv);
      //gap
      repeat(t.gap) begin
        @(vif.cb_drv);
      end
      //drive
      vif.cb_drv.in_vld <= '1;
      vif.cb_drv.data_in <= t.data & mask(DATA_W);
      `uvm_info("DRV_SOURCE", $sformatf("drive %0h", t.data & mask(DATA_W)), UVM_LOW);
      //wait hand_shake
      @(vif.cb_drv);
      while(!vif.cb_drv.in_rdy) begin
        @(vif.cb_drv);
      end
      //de-assert in_vld
      vif.cb_drv.in_vld <= '0;
      seq_item_port.item_done();
    end
  endtask
endclass