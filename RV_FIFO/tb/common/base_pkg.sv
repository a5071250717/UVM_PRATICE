package rv_base_pkg;
typedef enum int {SINK_RANDOM=0, SINK_ALWAYS_READY=1, SINK_ALWAYS_STALL=2} sink_mode_e;
typedef bit [63:0] u_64t;
function u_64t mask (int unsigned data_w);
  if(data_w >= 64)
    return '1;
  else
    return (u_64t'(1) << data_w) -1;
endfunction
parameter int unsigned DATA_W = 8;
parameter int unsigned DEPTH = 8;
typedef virtual RV_IF#(.data_w(DATA_W)) RV_VIF;
typedef virtual RV_IF#(.data_w(DATA_W)).drv RV_VIF_DRV;
typedef virtual RV_IF#(.data_w(DATA_W)).mon RV_VIF_MON;
endpackage