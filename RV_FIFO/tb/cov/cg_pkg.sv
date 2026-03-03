package rv_cg_pkg;
covergroup rv_cg(int unsigned MAX_BURST_LEN) with function sample(
  bit stall,
  bit bubble,
  int unsigned burst_len,
  int unsigned stall_len);
  
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
endgroup
endpackage