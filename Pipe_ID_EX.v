module ID_EX
(
    // Inputs
    input clk_i,
    input rst_i,
    input flush_i,
    input stall_i,
    
    // Pipe in/out
    input      [31:0] pc_i,
    output reg [31:0] pc_o,
    input      [31:0] data1_i,
    output reg [31:0] data1_o,
    input      [31:0] data2_i,
    output reg [31:0] data2_o,
    input      [31:0] sign_extended_i,
    output reg [31:0] sign_extended_o,
    input      [31:0] instruction_i,
    output reg [31:0] instruction_o,

    // Control Outputs
    input            RegDst_i,
    input            ALUSrc_i,
    input            MemToReg_i,
    input            RegWrite_i,
    input            MemWrite_i,
    input            ExtOp_i,
    input      [1:0] ALUOp_i,
    output reg       RegDst_o,
    output reg       ALUSrc_o,
    output reg       MemToReg_o,
    output reg       RegWrite_o,
    output reg       MemWrite_o,
    output reg       ExtOp_o,
    output reg [1:0] ALUOp_o
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        instruction_o <= 0;
        pc_o <= 0;
    end
    else begin
        if( !stall_i ) begin
            if( flush_i ) begin
                instruction_o <= 0;
                pc_o <= 0;
            end
            else begin
                pc_o <= pc_i;
                data1_o <= data1_i;
                data2_o <= data2_i;
                sign_extended_o <= sign_extended_i;
                instruction_o <= instruction_i;
                WB_o <= WB_i;
                M_o <= M_i;
                EX_o <= EX_i;
            end
        end
    end
end

endmodule
