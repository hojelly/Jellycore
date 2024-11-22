module frontend_RAT (
    input wire                  clk,
    input wire                  reset,
    input wire                  invalid1,
    input wire                  invalid2,
    input wire [`REG_SEL-1:0]   rs1_1,
    input wire [`REG_SEL-1:0]   rs2_1,
    input wire [`REG_SEL-1:0]   rs1_2,
    input wire [`REG_SEL-1:0]   rs2_2,
    input wire                  uses_rs1_1,
    input wire                  uses_rs2_1,
    input wire                  uses_rs1_2,
    input wire                  uses_rs2_2,
    input wire [`REG_SEL-1:0]   dst1,
    input wire [`REG_SEL-1:0]   dst2,
    input wire                  wr_reg1,
    input wire                  wr_reg2,
    input wire [`PHY_REG_SEL-1:0]   phy_dst_1,
    input wire [`PHY_REG_SEL-1:0]   phy_dst_2,
    output reg [`PHY_REG_SEL-1:0]   phy_src1_1,
    output reg [`PHY_REG_SEL-1:0]   phy_src2_1,
    output reg [`PHY_REG_SEL-1:0]   phy_src1_2,
    output reg [`PHY_REG_SEL-1:0]   phy_src2_2,
    output reg [`PHY_REG_SEL-1:0]   phy_ori_dst_1,
    output reg [`PHY_REG_SEL-1:0]   phy_ori_dst_2
);

    
    reg [`PHY_REG_SEL-1:0] mapping_table [`REG_NUM-1:0];
    reg [`PHY_REG_SEL:0] i = 0;


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < `REG_NUM; i = i + 1) begin
                mapping_table[i] <= {`PHY_REG_SEL{1'b0}}; // Initialize to zero
            end
        end else begin
            // Write Logic
            if (wr_reg1 && !invalid1) begin
                mapping_table[dst1] <= phy_dst_1;
            end
            if (wr_reg2 && !invalid2) begin
                mapping_table[dst2] <= phy_dst_2;
            end
        end
    end

    // Read logic: Map source registers to physical registers
    always @(*) begin
        // First instruction
        phy_src1_1 = uses_rs1_1 ? mapping_table[rs1_1] : {`PHY_REG_SEL{1'b0}};
        phy_src2_1 = uses_rs2_1 ? mapping_table[rs2_1] : {`PHY_REG_SEL{1'b0}};
        phy_ori_dst_1 = mapping_table[dst1];

        // Second instruction
        phy_src1_2 = uses_rs1_2 ? mapping_table[rs1_2] : {`PHY_REG_SEL{1'b0}};
        phy_src2_2 = uses_rs2_2 ? mapping_table[rs2_2] : {`PHY_REG_SEL{1'b0}};
        phy_ori_dst_2 = mapping_table[dst2];
    end

endmodule
