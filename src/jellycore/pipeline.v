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

   wire stall_DP;
   wire invalid1, invalid2;
   wire [`REG_SEL-1:0] rs1_1, rs2_1, dst1, rs1_2, rs2_2, dst2;
   wire uses_rs1_1, uses_rs2_1, wr_reg1, uses_rs1_2, uses_rs2_2, wr_reg2;

   wire [`PHY_REG_SEL-1:0] phy_src1_1, phy_src2_1, phy_dst1;
   wire [`PHY_REG_SEL-1:0] phy_src1_2, phy_src2_2, phy_dst2;

   wire [`PHY_REG_SEL-1:0] released_tag1, released_tag2;
   wire released_tag1_val, released_tag2_val;

   wire [`PHY_REG_SEL-1:0] phy_dst1_from_freelist, phy_dst2_from_freelist;
   wire allocatable;

   // Instantiate freelist
   freelist freelist_inst (
       .clk(clk),
       .reset(reset),
       .invalid1(invalid1),
       .invalid2(invalid2),
       .wr_reg_1(wr_reg1),
       .wr_reg_2(wr_reg2),
       .prmiss(1'b0), // No branch recovery yet
       .comnum(2'b10),
       .released_tag1(released_tag1),
       .released_tag2(released_tag2),
       .released_tag1_val(released_tag1_val),
       .released_tag2_val(released_tag2_val),
       .stall_DP(stall_DP),
       .phy_dst1(phy_dst1_from_freelist),
       .phy_dst2(phy_dst2_from_freelist),
       .phy_dst1_valid(),
       .phy_dst2_valid(),
       .allocatable(allocatable)
   );

   // Instantiate frontend_RAT
   frontend_RAT rat_inst (
       .clk(clk),
       .reset(reset),
       .invalid1(invalid1),
       .invalid2(invalid2),
       .rs1_1(rs1_1),
       .rs2_1(rs2_1),
       .rs1_2(rs1_2),
       .rs2_2(rs2_2),
       .uses_rs1_1(uses_rs1_1),
       .uses_rs2_1(uses_rs2_1),
       .uses_rs1_2(uses_rs1_2),
       .uses_rs2_2(uses_rs2_2),
       .dst1(dst1),
       .dst2(dst2),
       .wr_reg1(wr_reg1),
       .wr_reg2(wr_reg2),
       .phy_dst_1(phy_dst1),
       .phy_dst_2(phy_dst2),
       .phy_src1_1(phy_src1_1),
       .phy_src2_1(phy_src2_1),
       .phy_src1_2(phy_src1_2),
       .phy_src2_2(phy_src2_2),
       .phy_ori_dst_1(released_tag1),
       .phy_ori_dst_2(released_tag2)
   );

   // Instantiate renaming_logic
   renaming_logic renaming_inst (
       .clk(clk),
       .reset(reset),
       .invalid1(invalid1),
       .invalid2(invalid2),
       .rs1_1(rs1_1),
       .rs2_1(rs2_1),
       .dst1(dst1),
       .uses_rs1_1(uses_rs1_1),
       .uses_rs2_1(uses_rs2_1),
       .wr_reg1(wr_reg1),
       .rs1_2(rs1_2),
       .rs2_2(rs2_2),
       .dst2(dst2),
       .uses_rs1_2(uses_rs1_2),
       .uses_rs2_2(uses_rs2_2),
       .wr_reg2(wr_reg2),
       .phy_src1_1(phy_src1_1),
       .phy_src2_1(phy_src2_1),
       .phy_src1_2(phy_src1_2),
       .phy_src2_2(phy_src2_2),
       .phy_dst1_from_freelist(phy_dst1_from_freelist),
       .phy_dst2_from_freelist(phy_dst2_from_freelist),
       .allocatable(allocatable),
       .phy_dst1(phy_dst1),
       .phy_dst2(phy_dst2),
       .stall_pipeline(stall_DP)
   );

endmodule
