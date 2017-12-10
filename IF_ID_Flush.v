module IF_ID_Flush
(
    input Jump_i,
    input Branch_i,
    output Flush_o
);

assign Flush_o = (Jump_i || Branch_i);

endmodule
