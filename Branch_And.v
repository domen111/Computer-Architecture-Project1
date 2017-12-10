module Branch_And.v
(
    input Branch_i,
    input Equal_i,
    output Branch_o
);

assign Branch_o = (Branch_i && Equal_i);

endmodule
