`define Add 3'b010
`define Subtract 3'b110
`define Or 3'b001
`define And 3'b000
`define Mult 3'b100

module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input  [31:0] data1_i;
input  [31:0] data2_i;
input  [2:0]  ALUCtrl_i;
output [31:0] data_o;
output        Zero_o;

assign data_o = (ALUCtrl_i == `Add)      ? (data1_i + data2_i) :
                (ALUCtrl_i == `Subtract) ? (data1_i - data2_i) :
                (ALUCtrl_i == `Or)       ? (data1_i | data2_i) :
                (ALUCtrl_i == `And)      ? (data1_i & data2_i) :
                (ALUCtrl_i == `Mult)      ? (data1_i * data2_i) :
                data1_i;
assign Zero_o = (data1_i - data2_i == 0) ? 1 : 0;

endmodule
