module ShiftLeft2
(
    input  [25:0] data_i,
    output [27:0] data_o
);

assign data_o = data_i << 2;

endmodule
