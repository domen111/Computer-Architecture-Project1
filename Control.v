`define Rtype 6'b000000
`define addi   6'b001000

module Control
(
    Op_i, 
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input  [5:0] Op_i;
output       RegDst_o;
output [1:0] ALUOp_o;
output       ALUSrc_o;
output       RegWrite_o;

assign RegDst_o   = (Op_i == `Rtype);
assign ALUSrc_o   = (Op_i == `addi);
assign RegWrite_o = (Op_i == `Rtype || Op_i == `addi);
assign ALUOp_o    = (Op_i == `Rtype) ? 2'b11 :
                    (Op_i == `addi)  ? 2'b00 :
                    2'bxx;

endmodule
