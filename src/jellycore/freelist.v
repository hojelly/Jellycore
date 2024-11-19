`include "constants.vh"

module freelist(
        input wire          clk,
        input wire          reset,
        input wire          invalid1,
        input wire          invalid2,
        input wire          wr_reg_1,
        input wire          wr_reg_2,
        input wire          prmiss,
        input wire [1:0]    comnum,
        input wire [`PHY_REG_SEL-1:0] released_tag1,
        input wire [`PHY_REG_SEL-1:0] released_tag2,
        input wire          stall_DP,
        output wire [`PHY_REG_SEL-1:0]  phy_dst1,
        output wire [`PHY_REG_SEL-1:0]  phy_dst2,
        output wire                     allocatable,
        output reg [`PHY_REG_SEL:0]  freenum
        );

    // bit vectors indicates whether physcial register tag is free
    reg [`PHY_REG_NUM-1:0] free_bits;
    wire [`PHY_REG_SEL-1:0] alloc_dst1;
    wire [`PHY_REG_SEL-1:0] alloc_dst2;

    wire [1:0] reqnum = {1'b0, ~invalid1 & wr_reg_1} + {1'b0, ~invalid2 & wr_reg_2};

    assign allocatable = (freenum + comnum) < reqnum ? 1'b0 : 1'b0;

    always @ (posedge clk) begin
        if(reset) begin
            freenum <= `PHY_REG_NUM;
        end else if(stall_DP) begin
            freenum <= freenum + comnum;
        end
    end

endmodule