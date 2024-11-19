`include "constants.vh"
`include "alu_ops.vh"
`include "rv32_opcodes.vh"

`default_nettype none

module pipeline
  (
   input wire 			clk,
   input wire 			reset,
   output reg [`ADDR_LEN-1:0] 	pc,
   input wire [4*`INSN_LEN-1:0] idata,
   output wire [`DATA_LEN-1:0] 	dmem_wdata,
   output wire 			dmem_we,
   output wire [`ADDR_LEN-1:0] 	dmem_addr,
   input wire [`DATA_LEN-1:0] 	dmem_data
   );
   wire  stall_IF;
   wire  kill_IF;
   wire  stall_ID;
   wire  kill_ID;
   wire  stall_DP;
   wire  kill_DP;

   

endmodule
