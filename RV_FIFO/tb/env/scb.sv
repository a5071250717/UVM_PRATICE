class rv_scb extends uvm_scoreboard;
  `uvm_component_utils(rv_scb)
  //`uvm_analysis_imp_decl(_in)
  //uvm_analysis_imp_in#(u_64t, rv_scb);
  uvm_tlm_analysis_fifo#(u_64t) fifo_in;
  uvm_tlm_analysis_fifo#(u_64t) fifo_out;
  int unsigned cnt_in = 0, cnt_out = 0;
  int unsigned n_times = 0;
  event sink_done;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    fifo_in = new("fifo_in", this);
    fifo_out = new("fifo_out", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    u_64t data_in, data_out;
    forever begin
      fifo_in.get(data_in);
      cnt_in ++;
      fifo_out.get(data_out);
      if(data_in != data_out)
        `uvm_error("SCB", $sformatf("mismatch get = %0h, exp = %0h", data_in, data_out));
      cnt_out ++;
      if(cnt_out == n_times)begin
      	-> sink_done;
      end
    end
  endtask
  function void report_phase(uvm_phase phase);
    if(cnt_in == cnt_out)begin
      `uvm_info("SCB", "Pass", UVM_LOW);
    end
    else
      `uvm_info("SCB", "Fail", UVM_LOW);
  endfunction
endclass