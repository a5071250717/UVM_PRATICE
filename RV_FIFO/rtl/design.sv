`include "dut_if.sv"

// Code your design here
module RV_FIFO#(parameter data_w = 8, parameter depth = 8)(RV_IF.dut if_);
  
  logic clk, rstn;
  //up_stream
  logic in_vld, out_rdy;
  logic [data_w-1: 0] data_in;

  //down_stream
  logic out_vld, in_rdy;
  logic [data_w-1: 0] data_out;
  
  //for interface and input connection
  assign clk = if_.clk;
  assign rstn = if_.rstn;
  assign in_vld = if_.in_vld;
  assign out_rdy = if_.out_rdy;
  assign data_in = if_.data_in;
  
  //internal reg
  logic [data_w-1: 0] mem [depth-1: 0];
  
  parameter addr_w = $clog2(depth);
  logic [addr_w: 0] w_ptr, r_ptr;
  logic [addr_w-1: 0] w_addr, r_addr;
  assign w_addr = w_ptr[addr_w-1: 0];
  assign r_addr = r_ptr[addr_w-1: 0];
  
  logic empty, full;
  assign empty = (w_ptr == r_ptr);
  assign full = (w_addr == r_addr) && (w_ptr != r_ptr);
  
  
  assign in_rdy = (!full || (full & out_rdy));
  assign out_vld = (!empty || (empty & in_vld));
  
  logic push, pop;
  assign push = in_vld && in_rdy;
  assign pop = out_vld && out_rdy;
 
  //for interface and output connection
  assign if_.out_vld = out_vld;
  assign if_.in_rdy = in_rdy;
  assign if_.data_out = data_out;
  assign if_.empty = empty;
  assign if_.full = full;
  
  //update ptr
  always @ (posedge clk) begin
    if(!rstn) begin
      w_ptr <= '0;
      r_ptr <= '0;
    end
    else begin
      w_ptr <= push? w_ptr + 1: w_ptr;
      r_ptr <= pop? r_ptr + 1: r_ptr;
    end
  end
  
  //update mem, data_out
  always @ (posedge clk) begin
    if(!rstn) begin
      mem = '{default: 0};
      data_out <= 0;
    end
    else begin
      if(push) begin
        mem[w_addr] <= data_in;
        //$display("[%t] push %0h", $time, data_in & mask(DATA_W));
      end
      if(pop)begin
        if(empty) begin
          data_out <= data_in;
          //$display("[%t] pop %0h", $time, data_in & mask(DATA_W));
        end
        else begin
          data_out <= mem[r_addr];
        	//$display("[%t] pop %0h", $time, mem[r_addr] & mask(DATA_W));
        end
      end
    end
  end
  
endmodule