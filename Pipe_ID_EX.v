module ID_EX
(
    // Inputs
    input clk_i,
    input rst_i,
    input memStall_i,
        
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
    input            MemRead_i,
    input            ExtOp_i,
    input      [1:0] ALUOp_i,
    output reg       RegDst_o,
    output reg       ALUSrc_o,
    output reg       MemToReg_o,
    output reg       RegWrite_o,
    output reg       MemWrite_o,
    output reg       MemRead_o,
    output reg       ExtOp_o,
    output reg [1:0] ALUOp_o
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        instruction_o <= 0;
        pc_o <= 0;
        data1_o <= 0;
        data2_o <= 0;
        sign_extended_o <= 0;
        RegDst_o <= 0;
        ALUSrc_o <= 0;
        MemToReg_o <= 0;
        RegWrite_o <= 0;
        MemWrite_o <= 0;
        MemRead_o <= 0;
        ExtOp_o <= 0;
        ALUOp_o <= 0;
    end
    else begin
        pc_o <= pc_i;
        data1_o <= data1_i;
        data2_o <= data2_i;
        sign_extended_o <= sign_extended_i;
        instruction_o <= instruction_i;
        RegDst_o <= RegDst_i;
        ALUSrc_o <= ALUSrc_i;
        MemToReg_o <= MemToReg_i;
        RegWrite_o <= RegWrite_i;
        MemWrite_o <= MemWrite_i;
        MemRead_o <=  MemRead_i;
        ExtOp_o <= ExtOp_i;
        ALUOp_o <= ALUOp_i;
    end
end

endmodule
