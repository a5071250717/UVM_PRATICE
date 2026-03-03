class rv_sub extends uvm_subscriber#(rv_txn_sub);
  `uvm_component_utils(rv_sub)
  rv_cg cg;
  parameter int unsigned MAX_BURST_LEN = DEPTH;
  bit stall, bubble, burst;
  int unsigned stall_len = 0, burst_len = 0;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cg = new(MAX_BURST_LEN);
  endfunction
  
  function void write(rv_txn_sub t);
    stall = t.out_vld & !t.out_rdy;
    bubble = !t.out_vld;
    burst = t.out_vld & t.out_rdy;
    //stall_len
    stall_len = stall? stall_len+1: 0;
    
    //burst_len
    burst_len = burst?  burst_len+1: 0;
    
    cg.sample(stall, bubble, burst_len, stall_len);
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SUB", $sformatf("coverage rate is %0f", cg.get_inst_coverage), UVM_LOW);
  endfunction
endclass