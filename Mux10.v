module Mux10
(
    data0_i,
    data1_i,
    select_i,
    data_o
);

input   [9:0]  data0_i;
input   [9:0]  data1_i;
input          select_i;
output  [9:0]  data_o;

assign data_o = select_i ? data1_i : data0_i;

endmodule
