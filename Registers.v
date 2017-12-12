module Registers
(
    clk_i,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i, 
    RDdata_i,
    RegWrite_i, 
    RSdata_o, 
    RTdata_o 
);

// Ports
input               clk_i;
input   [4:0]       RSaddr_i;
input   [4:0]       RTaddr_i;
input   [4:0]       RDaddr_i;
input   [31:0]      RDdata_i;
input               RegWrite_i;
output reg [31:0]      RSdata_o; 
output reg [31:0]      RTdata_o;

// Register File
reg     [31:0]      register        [0:31];

// Read Data      
// assign RSdata_o = //(RegWrite_i && (RSaddr_i==RDaddr_i)) ? RDdata_i : 
//                     register[RSaddr_i];
// assign RTdata_o = //(RegWrite_i && (RTaddr_i==RDaddr_i)) ? RDdata_i : 
//                     register[RTaddr_i];
always @(*) begin
    RSdata_o <= register[RSaddr_i];
    RTdata_o <= register[RTaddr_i];
    if(RegWrite_i) begin
        if(RSaddr_i==RDaddr_i) RSdata_o <= RDdata_i;
        if(RTaddr_i==RDaddr_i) RTdata_o <= RDdata_i;
    end
end

// Write Data   
always@(posedge clk_i) begin
    if(RegWrite_i) begin
        register[RDaddr_i] <= RDdata_i;
        $display("register: RDdata_i %d", RDdata_i);
    end
end
   
endmodule 
