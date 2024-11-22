`include "constants.vh"
// recovery is not implemented yet
module freelist(
        input wire          clk,
        input wire          reset,
        input wire          invalid1,
        input wire          invalid2,
        input wire          wr_reg_1,
        input wire          wr_reg_2,
        input wire          prmiss,
        input wire [1:0]    comnum,
        input wire [`PHY_REG_SEL-1:0]   released_tag1,
        input wire [`PHY_REG_SEL-1:0]   released_tag2,
        input wire                      released_tag1_val,
        input wire                      released_tag2_val,
        input wire          stall_DP,   // if back-end stalls
        output reg [`PHY_REG_SEL-1:0]   phy_dst1,
        output reg [`PHY_REG_SEL-1:0]   phy_dst2,
        output reg                      phy_dst1_valid,
        output reg                      phy_dst2_valid,
        output wire                      allocatable
        );

    // bit vectors indicates whether physcial register tag is free
    reg [`PHY_REG_NUM-1:0]  free_bits;
    reg [`PHY_REG_SEL:0]    freenum;
    reg                     alloc_prev;
    reg [1:0]               count;
    reg [`PHY_REG_SEL:0]    i;
    wire [1:0]              reqnum;

    assign reqnum = {1'b0, ~invalid1 & wr_reg_1} + {1'b0, ~invalid2 & wr_reg_2};
    assign allocatable = (freenum >= reqnum) ? 1'b1 : 1'b0;

    // No stall_DP -> alloc tags
    // stall_DP but alloc failed in previous cycle-> alloc tags
    // stall_DP and alloc succeeded in previous cycle -> same tags
    always @ (*) begin
        if (allocatable && (~stall_DP || (stall_DP && ~alloc_prev))) begin
            phy_dst1_valid = 0;
            phy_dst2_valid = 0;
            count = 0;
            // Finding free physical registers
            for (i = 0; i < `PHY_REG_NUM && count < reqnum; i++) begin
                if (free_bits[i]) begin
                    if (count == 0 && wr_reg_1) begin
                        phy_dst1 = i;
                        phy_dst1_valid = 1;
                    end else begin
                        phy_dst2 = i;
                        phy_dst2_valid = 1;
                    end
                    count = count + 1;
                end
            end
        end else begin
            phy_dst1 = phy_dst1;
            phy_dst2 = phy_dst2;
            phy_dst1_valid = phy_dst1_valid;
            phy_dst2_valid = phy_dst2_valid;
        end
    end

    always @ (negedge clk) begin
        if(reset) begin
            freenum <= `PHY_REG_NUM;
            free_bits <= {`PHY_REG_NUM{1'b1}};
            alloc_prev <= 1'b1;
            count <= 0;
            i <= 0;

        end else if (prmiss) begin
            // dealing with branch misprediction
        end else begin
            freenum <= freenum + comnum - {1'b0, phy_dst1_valid} - {1'b0, phy_dst2_valid};
            free_bits <= (free_bits
                         // Add released tags
                         | ({`PHY_REG_NUM{released_tag1_val}} & (1'b1 << released_tag1))
                         | ({`PHY_REG_NUM{released_tag2_val}} & (1'b1 << released_tag2))
                         // Remove newly allocated tags
                         & ~({`PHY_REG_NUM{phy_dst1_valid}} & (1'b1 << phy_dst1))
                         & ~({`PHY_REG_NUM{phy_dst2_valid}} & (1'b1 << phy_dst2)));
            alloc_prev <= allocatable;
        end
    end

endmodule