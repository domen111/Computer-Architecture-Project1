module Mux32_3
(
    data0_i,
    data1_i,
    data2_i,
    select_i,
    data_o
);

input   [31:0]  data0_i;
input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [1:0]   select_i;
output  [31:0]  data_o;

assign data_o = (select_i == 2'b00) ? data0_i :
                (select_i == 2'b01) ? data1_i :
                (select_i == 2'b10) ? data2_i :
                32'hxxxxxxxx;

endmodule
