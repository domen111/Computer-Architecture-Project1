`define ZeroReg 5'b00000

module Forwarding_Unit
(
    input [4:0] DecRsAddr_i,
    input [4:0] DecRtAddr_i,
    input ExMemRegWrite_i,
    input [4:0] ExMemRdAddr_i,
    input MemWbRegWrite_i,
    input [4:0] MemWbRdAddr_i,
    output reg [1:0] DecRsOverride_o,
    output reg [1:0] DecRtOverride_o
);

always @(*)
begin
    
    // default
    DecRsOverride_o = 2'b00;
    DecRtOverride_o = 2'b00;
    
    if(ExMemRegWrite_i && (ExMemRdAddr_i != `ZeroReg))
    begin
        if(ExMemRdAddr_i == DecRsAddr_i)
            DecRsOverride_o <= 2'b10;
        if(ExMemRdAddr_i == DecRtAddr_i)
            DecRtOverride_o <= 2'b10;
    end

    if(MemWbRegWrite_i && (MemWbRdAddr_i != `ZeroReg))
    begin
        if(ExMemRdAddr_i != DecRsAddr_i &&
          (MemWbRdAddr_i == DecRsAddr_i))
            DecRsOverride_o <= 2'b01;
        if(ExMemRdAddr_i != DecRtAddr_i &&
          (MemWbRdAddr_i == DecRtAddr_i))
            DecRtOverride_o <= 2'b01;
    end
end

endmodule
