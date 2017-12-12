`define Rtype 6'b000000
`define addi  6'b001000
`define lw    6'b100011
`define sw    6'b101011
`define beq   6'b000100
`define jump  6'b000010

module Control
(
    Op_i, 
    RegDst_o,
    ALUSrc_o,
    MemToReg_o,
    RegWrite_o,
    MemWrite_o,
    MemRead_o,
    Branch_o,
    Jump_o,
    ExtOp_o,
    ALUOp_o,
);

input  [5:0] Op_i;
output       RegDst_o;
output       ALUSrc_o;
output       MemToReg_o;
output       RegWrite_o;
output       MemWrite_o;
output       MemRead_o;
output       Branch_o;
output       Jump_o;
output       ExtOp_o;
output [1:0] ALUOp_o;

assign RegDst_o   = (Op_i == `Rtype);
assign ALUSrc_o   = (Op_i == `addi || Op_i == `lw || Op_i == `sw);
assign MemToReg_o = (Op_i == `lw);
assign RegWrite_o = (Op_i == `Rtype || Op_i == `addi || Op_i == `lw);
assign MemWrite_o = (Op_i == `sw);
assign MemRead_o  = (Op_i == `lw);
assign Branch_o   = (Op_i == `beq);
assign Jump_o     = (Op_i == `jump);
assign ALUOp_o    = (Op_i == `Rtype) ? 2'b11 :
                    (Op_i == `addi)  ? 2'b00 :
                    (Op_i == `lw)    ? 2'b00 :
                    (Op_i == `sw)    ? 2'b00 :
                    (Op_i == `beq)   ? 2'b01 :
                    2'bxx;

endmodule
