`define ZeroReg 5'b00000

module Forwarding_Unit
(
    input [4:0] ID_EX_RsAddr_i,
    input [4:0] ID_EX_RtAddr_i,
    input EX_MEM_RegWrite_i,
    input [4:0] EX_MEM_RdAddr_i,
    input MEM_WB_RegWrite_i,
    input [4:0] MEM_WB_RdAddr_i,
    output [1:0] EX_RsOverride_o,
    output [1:0] EX_RtOverride_o
);

reg [1:0] EX_RsOverride_o_temp;
reg [1:0] EX_RtOverride_o_temp;

always @(*)
begin
    
    // default
    EX_RsOverride_o_temp = 2'b00;
    EX_RtOverride_o_temp = 2'b00;
    
    if(EX_MEM_RegWrite_i && (EX_MEM_RdAddr_i != `ZeroReg))
    begin
        if(EX_MEM_RdAddr_i == ID_EX_RsAddr_i)
            EX_RsOverride_o_temp <= 2'b10;
        if(EX_MEM_RdAddr_i == ID_EX_RtAddr_i)
            EX_RtOverride_o_temp <= 2'b10;
    end

    if(MEM_WB_RegWrite_i && (EX_MEM_RdAddr_i != `ZeroReg))
    begin
        if(EX_MEM_RdAddr_i != ID_EX_RsAddr_i &&
          (MEM_WB_RdAddr_i == ID_EX_RsAddr_i))
            EX_RsOverride_o_temp <= 2'b01;
        if(EX_MEM_RdAddr_i != ID_EX_RtAddr_i &&
          (MEM_WB_RdAddr_i == ID_EX_RtAddr_i))
            EX_RtOverride_o_temp <= 2'b01;
    end
end

assign EX_RsOverride_o = EX_RsOverride_o_temp;
assign EX_RtOverride_o = EX_RtOverride_o_temp;

endmodule
