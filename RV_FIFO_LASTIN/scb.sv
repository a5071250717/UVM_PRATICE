class rv_scb extends uvm_scoreboard;
  `uvm_component_utils(rv_scb)
  `uvm_analysis_imp_decl(_in)
  `uvm_analysis_imp_decl(_out)
  uvm_analysis_imp_in#(fifo_entry_t, rv_scb) imp_in;
  uvm_analysis_imp_out#(fifo_entry_t, rv_scb) imp_out;
  int unsigned pkg_num, pkg_num_in, pkg_num_out = 0;
  fifo_entry_t q[$];
  event sink_done;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp_in = new("imp_in", this);
    imp_out = new("imp_out", this);
  endfunction
  
  function void write_in(fifo_entry_t t_in);
    q.push_back(t_in);
    if(t_in.last)
      pkg_num_in ++;
  endfunction
  
  function void write_out(fifo_entry_t t_out);
    fifo_entry_t t_in;
    t_in = q.pop_front;
    if (t_in.data != t_out.data || t_in.last != t_out.last) begin
      `uvm_error("SCB", $sformatf("Exp data = %0h, actual data = %0h", t_in.data, t_out.data)); 
      `uvm_error("SCB", $sformatf("Exp last_in = %0h, actual last_in = %0h", t_in.last, t_out.last));
    end
    if(t_out.last)
      pkg_num_out ++;
    if (pkg_num_out == pkg_num)
      ->sink_done;
  endfunction
  
  function void report_phase(uvm_phase phase);
    if(pkg_num_in == pkg_num_out)begin
      `uvm_info("SCB", "Pass", UVM_LOW);
    end
    else
      `uvm_info("SCB", "Fail", UVM_LOW);
  endfunction
endclass