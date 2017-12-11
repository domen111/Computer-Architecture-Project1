module EX_MEM
(
    // Inputs
    input clk_i,
    input rst_i,
    
    // Pipe in/out
    input      [31:0] ALU_Res_i,
    output reg [31:0] ALU_Res_o,
    input             Write_Data_i,
    output reg        Write_Data_o,
    input      [31:0] RdAddr_i,
    output reg [31:0] RdAddr_o,

    // Control Outputs
    input            MemToReg_i,
    input            RegWrite_i,
    input            MemWrite_i,
    input            ExtOp_i,
    output reg       MemToReg_o,
    output reg       RegWrite_o,
    output reg       MemWrite_o,
    output reg       ExtOp_o,
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        pc_o <= 0;
    end
    else begin
        pc_o <= pc_i;
        ALU_Res_o <= ALU_Res_i;
        Write_Data_o <= Write_Data_i;
        Forward_Data_o <= Forward_Data_i;
        WB_o <= WB_i;
        M_o <= M_i;
    end
end

endmodule
