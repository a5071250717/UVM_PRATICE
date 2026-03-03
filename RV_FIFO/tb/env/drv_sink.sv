class rv_drv_sink extends uvm_driver#(rv_txn);
  `uvm_component_utils(rv_drv_sink)
  RV_VIF_DRV vif;
  sink_mode_e mode = SINK_RANDOM, mode_prev = SINK_RANDOM;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(RV_VIF_DRV)::get(this, "", "vif_drv", vif))
      `uvm_fatal("DRV_SINK", "Did not set vif_drv");   
  endfunction
  
  task run_phase(uvm_phase phase);
    rv_txn t;
    vif.cb_drv.out_rdy <= 0;
    @(posedge vif.rstn);
    forever begin
      // 取得 mode
      if (!uvm_config_db#(sink_mode_e)::get(this, "", "sink_mode", mode)) begin
        `uvm_fatal("DRV_SINK", "Did not set sink_mode");
      end
      // mode 變了才印，避免爆 log
      if (mode != mode_prev) begin
        `uvm_info("DRV_SINK", $sformatf("sink_mode -> %0d", mode), UVM_LOW);
        mode_prev = mode;
      end
      
      @(vif.cb_drv);
      case(mode)
      	SINK_RANDOM: 
          vif.cb_drv.out_rdy <= ($urandom_range(1,10) < 3);
        SINK_ALWAYS_READY: 
          vif.cb_drv.out_rdy <= 1;
        SINK_ALWAYS_STALL: 
          vif.cb_drv.out_rdy <= 0;
      endcase
    end
  endtask
endclass