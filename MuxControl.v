module MuxControl
(
    stall_i,
    RegDst_i,
    ALUSrc_i,
    MemToReg_i,
    RegWrite_i,
    MemWrite_i,
    Branch_i,
    Jump_i,
    ExtOp_i,
    ALUOp_i,
    RegDst_o,
    ALUSrc_o,
    MemToReg_o,
    RegWrite_o,
    MemWrite_o,
    Branch_o,
    Jump_o,
    ExtOp_o,
    ALUOp_o,
);

input        stall_i;
input        RegDst_i;
input        ALUSrc_i;
input        MemToReg_i;
input        RegWrite_i;
input        MemWrite_i;
input        Branch_i;
input        Jump_i;
input        ExtOp_i;
input [1:0]  ALUOp_i;
output       RegDst_o;
output       ALUSrc_o;
output       MemToReg_o;
output       RegWrite_o;
output       MemWrite_o;
output       Branch_o;
output       Jump_o;
output       ExtOp_o;
output [1:0] ALUOp_o;

assign RegDst_o   = (stall_i? 1'b0 : RegDst_i);
assign ALUSrc_o   = (stall_i? 1'b0 : ALUSrc_i);
assign MemToReg_o = (stall_i? 1'b0 : MemToReg_i);
assign RegWrite_o = (stall_i? 1'b0 : RegWrite_i);
assign MemWrite_o = (stall_i? 1'b0 : MemWrite_i);
assign Branch_o   = (stall_i? 1'b0 : Branch_i);
assign Jump_o     = (stall_i? 1'b0 : Jump_i);
assign ExtOp_o    = (stall_i? 1'b0 : ExtOp_i);
assign ALUOp_o    = (stall_i? 2'b00 : ALUOp_i);

endmodule
