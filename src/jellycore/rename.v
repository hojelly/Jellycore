`include "constants.vh"


module rename_logic(
        input wire [`REG_SEL-1:0]   rs1_1,
        input wire [`REG_SEL-1:0]   rs2_1,
        input wire [`REG_SEL-1:0]   rd_1,
        input wire                  wr_reg_1,
        input wire                  uses_rs1_1,
        input wire                  uses_rs2_1,
        input wire [`REG_SEL-1:0]   rs1_2,
        input wire [`REG_SEL-1:0]   rs2_2,
        input wire [`REG_SEL-1:0]   rd_2,
        input wire                  wr_reg_2,
        input wire                  uses_rs1_2,
        input wire                  uses_rs2_2,
        output wire                     empty_freelist,
        output wire [`PHY_REG_SEL-1:0]  ps1_1,
        output wire [`PHY_REG_SEL-1:0]  ps2_1,
        output wire [`PHY_REG_SEL-1:0]  pd_1,
        output wire [`PHY_REG_SEL-1:0]  pd_org_1,
        output wire [`PHY_REG_SEL-1:0]  ps1_1,
        output wire [`PHY_REG_SEL-1:0]  ps2_1,
        output wire [`PHY_REG_SEL-1:0]  pd_1,
        output wire [`PHY_REG_SEL-1:0]  pd_org_1
        );

    

endmodule