interface RV_IF #(parameter data_w = 8)(
  input logic clk,
  input logic rstn
);
  
  //up_stream
  logic in_vld, out_rdy;
  logic [data_w-1: 0] data_in;

  //down_stream
  logic out_vld, in_rdy;
  logic [data_w-1: 0] data_out;  
  
  //status
  logic empty;
  logic full;
  
  modport dut(
  	input clk, rstn, in_vld, out_rdy, data_in, 
    output in_rdy, out_vld, data_out,
    empty, full
  );
   
  //dut modport + cb
  clocking cb_drv @(posedge clk);
    default input #1step output #0;
    input in_rdy;
    output data_in, in_vld, out_rdy;
  endclocking
  
  clocking cb_mon @(posedge clk);
    default input #1step output #0;
    input data_in, in_vld, in_rdy, out_vld, out_rdy;
    input empty, full;
    input #0 data_out;
  endclocking
  
  modport drv(input clk,rstn, clocking cb_drv);
  modport mon(input clk,rstn, clocking cb_mon);    
  
    
      
endinterface