module renaming_logic (
    input wire                  clk,
    input wire                  reset,
    input wire                  invalid1,
    input wire                  invalid2,
    input wire [`REG_SEL-1:0]   rs1_1,
    input wire [`REG_SEL-1:0]   rs2_1,
    input wire [`REG_SEL-1:0]   dst1,
    input wire                  uses_rs1_1,
    input wire                  uses_rs2_1,
    input wire                  wr_reg1,
    input wire [`REG_SEL-1:0]   rs1_2,
    input wire [`REG_SEL-1:0]   rs2_2,
    input wire [`REG_SEL-1:0]   dst2,
    input wire                  uses_rs1_2,
    input wire                  uses_rs2_2,
    input wire                  wr_reg2,
    input wire [`PHY_REG_SEL-1:0] phy_src1_1,
    input wire [`PHY_REG_SEL-1:0] phy_src2_1,
    input wire [`PHY_REG_SEL-1:0] phy_src1_2,
    input wire [`PHY_REG_SEL-1:0] phy_src2_2,
    input wire [`PHY_REG_SEL-1:0] phy_dst1_from_freelist,
    input wire [`PHY_REG_SEL-1:0] phy_dst2_from_freelist,
    input wire                  allocatable,
    output reg [`PHY_REG_SEL-1:0] phy_dst1,
    output reg [`PHY_REG_SEL-1:0] phy_dst2,
    output reg                  stall_pipeline
);

    always @(*) begin
        // Initialize outputs
        phy_dst1 = {`PHY_REG_SEL{1'b0}};
        phy_dst2 = {`PHY_REG_SEL{1'b0}};
        stall_pipeline = 1'b0;

        // Stall if registers cannot be allocated
        if (!allocatable) begin
            stall_pipeline = 1'b1;
        end else begin
            // Rename destination registers
            if (!invalid1 && wr_reg1) begin
                phy_dst1 = phy_dst1_from_freelist;
            end
            if (!invalid2 && wr_reg2) begin
                phy_dst2 = phy_dst2_from_freelist;
            end

            // Handle WAW dependency
            if (wr_reg1 && wr_reg2 && (dst1 == dst2)) begin
                phy_dst2 = phy_dst2_from_freelist; // Assign a different physical register
            end
        end
    end

endmodule
