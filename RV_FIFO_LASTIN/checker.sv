module rv_checker(RV_IF if_);
  default clocking cb @(posedge if_.clk); endclocking
  default disable iff (!if_.rstn);

  // 1) out_data 在 backpressure 期間要穩
  a_stable_when_stall: assert property (if_.out_vld && !if_.out_rdy |=> $stable(if_.data_out));

  a_reset_to_empty_proxy: assert property ($rose(if_.rstn) |-> (if_.out_vld == 1'b0));

  property a_full_blocks_input;
    (if_.full && if_.out_rdy) |-> if_.in_rdy;
  endproperty
    
  /*property a_empty_passthrough;
    if_.empty |-> (if_.in_vld == if_.out_vld);
  endproperty
  */
  
  property a_not_empty_implies_out_vld;
    !if_.empty |-> if_.out_vld;
  endproperty
  assert property(a_full_blocks_input);
  //assert property(a_empty_passthrough);    
    
  
endmodule