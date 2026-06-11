package rv_cg_pkg;
covergroup rv_cg(int unsigned MAX_BURST_LEN) with function sample(
  bit stall,
  bit bubble,
  bit backpresure_on_last,
  int unsigned burst_len,
  int unsigned pkt_len,
  int unsigned stall_len);

  option.per_instance = 1;

  STALL: coverpoint stall{
    bins zero = {0};
    bins one = {1};
  }  
  BUBBLE: coverpoint bubble{
    bins zero = {0};
    bins one = {1};
  }
  
  BURST_LEN: coverpoint burst_len{
    bins low = {[0: MAX_BURST_LEN/3]};
    bins mid = {[MAX_BURST_LEN/3+1: MAX_BURST_LEN-1]};
    bins max = {MAX_BURST_LEN};
  }  
  STALL_LEN: coverpoint stall_len{
    bins low = {[0: 3]};
    bins mid = {[4: 6]};
    bins max = {[7: $]};
  }
  PKT_LEN: coverpoint pkt_len{
    bins low = {1};
    bins mid = {[2:3]};
    bins high = {4};
  }
  BACKPRESURE_ON_LAST: coverpoint backpresure_on_last {
    bins one = {1};
    bins zero = {0};
  }
  //cross coverage
  //CX_LEN_BURST_STALL: cross burst_len, stall_len;
  CX_BURST_STALL: cross BUBBLE, STALL {
    ignore_bins impossiable = binsof(BUBBLE.one) && binsof(STALL.one); 
  }
  
endgroup
endpackage