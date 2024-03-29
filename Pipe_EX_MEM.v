module EX_MEM
(
    // Inputs
    input clk_i,
    input rst_i,
    
    // Pipe in/out
    input      [31:0] ALU_Res_i,
    output reg [31:0] ALU_Res_o,
    input      [31:0] Write_Data_i,
    output reg [31:0] Write_Data_o,
    input      [4:0]  RdAddr_i,
    output reg [4:0]  RdAddr_o,

    // Control Outputs
    input            MemToReg_i,
    input            RegWrite_i,
    input            MemWrite_i,
    input            MemRead_i,
    input            ExtOp_i,
    output reg       MemToReg_o,
    output reg       RegWrite_o,
    output reg       MemWrite_o,
    output reg       MemRead_o,
    output reg       ExtOp_o
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        ALU_Res_o <= 0;
        Write_Data_o <= 0;
        RdAddr_o <= 0;
        MemToReg_o <= 0;
        RegWrite_o <= 0;
        MemWrite_o <= 0;
        MemRead_o <= 0;
        ExtOp_o <= 0;
    end
    else begin
        ALU_Res_o <= ALU_Res_i;
        Write_Data_o <= Write_Data_i;
        RdAddr_o <= RdAddr_i;
        MemToReg_o <= MemToReg_i;
        RegWrite_o <= RegWrite_i;
        MemWrite_o <= MemWrite_i;
        MemRead_o <= MemRead_i;
        ExtOp_o <= ExtOp_i;
    end
end

endmodule
