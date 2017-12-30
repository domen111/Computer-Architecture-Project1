module MEM_WB
(
    // Inputs
    input clk_i,
    input rst_i,
    input memStall_i,
        
    // Pipe in/out
    input      [31:0] ALU_Res_i,
    output reg [31:0] ALU_Res_o,
    input      [31:0] Read_Data_i,
    output reg [31:0] Read_Data_o,
    input      [4:0]  RdAddr_i,
    output reg [4:0]  RdAddr_o,
    input             MemToReg_i,
    input             RegWrite_i,
    output reg        MemToReg_o,
    output reg        RegWrite_o
);

always @(posedge clk_i or negedge rst_i) begin
    ALU_Res_o <= ALU_Res_i;
    Read_Data_o <= Read_Data_i;
    RdAddr_o <= RdAddr_i;
    MemToReg_o <= MemToReg_i;
    RegWrite_o <= RegWrite_i;
end

endmodule
