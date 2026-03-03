// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;
// self-define data_type
`include "base_pkg.sv"
import rv_base_pkg::*;
// covergroup def
`include "cg_pkg.sv"
// all uvm_* file
`include "file_pkg.sv"
import rv_file_pkg::*;

// checker module
`include "checker.sv"
module top;
  logic clk, rstn;
  always #5 clk = ~clk;
  
  //Interfcae
  RV_IF #(.data_w(DATA_W)) rv_if (.clk(clk),
                                  .rstn(rstn));   
  //DUT
  RV_FIFO #(.data_w(DATA_W), .depth(DEPTH)) rv_fifo (.if_(rv_if.dut)); 
  //Checker
  rv_checker sva (.if_(rv_if));
  initial begin
    clk = 0;
    rstn = 0;
    #50;
    rstn = 1;
  end
  
  initial begin
    uvm_config_db#(RV_VIF)::set(null, "uvm_test_top", "vif", rv_if);
    uvm_config_db#(RV_VIF_DRV)::set(null, "*", "vif_drv", rv_if.drv);
    uvm_config_db#(RV_VIF_MON)::set(null, "*", "vif_mon", rv_if.mon);    
  end
  initial begin
    $dumpvars(0);
    $dumpfile("dump.vcd");
    run_test("rv_d_test_full_to_empty");
  end
  
  
endmodule