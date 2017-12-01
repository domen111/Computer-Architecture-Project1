`define Add 3'b010
`define Subtract 3'b110
`define Or 3'b001
`define And 3'b000
`define Mult 3'b100

module ALU_Control
(
    funct_i, 
    ALUOp_i,
    ALUCtrl_o
);

input  [5:0] funct_i;
input  [1:0] ALUOp_i;
output [2:0] ALUCtrl_o;

assign ALUCtrl_o = (ALUOp_i == 2'b00) ? `Add:
                   (ALUOp_i == 2'b01) ? `Subtract:
                   (ALUOp_i == 2'b10) ? `Or:
                   (funct_i == 6'h20) ? `Add:
                   (funct_i == 6'h22) ? `Subtract:
                   (funct_i == 6'h24) ? `And:
                   (funct_i == 6'h25) ? `Or:
                   (funct_i == 6'h18) ? `Mult:
                   3'bxxx;

endmodule
