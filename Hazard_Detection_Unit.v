module Hazard_Detection_Unit
(
    input ID_EX_MemRead_i,
    input [4:0] IF_ID_RsAddr_i,
    input [4:0] IF_ID_RtAddr_i,
    input [4:0] ID_EX_RtAddr_i,
    // output reg PC_Stall_o,
    // output reg IF_ID_Stall_o,
    // output reg stall_o
    output stall_o
);


assign stall_o = (ID_EX_MemRead_i && ((ID_EX_RtAddr_i == IF_ID_RsAddr_i) || (ID_EX_RtAddr_i == IF_ID_RtAddr_i)) ) ? 1'b1 : 1'b0;

// initial begin
//     stall_o = 1'b0;
// end

// always@(*)
// begin
    
//     // default
//     // PC_Stall_o = 1'b0;
//     // IF_ID_Stall_o = 1'b0;
//     stall_o = 1'b0;

//     if(ID_EX_MemRead_i && ((ID_EX_RtAddr_i == IF_ID_RsAddr_i) ||
//                          (ID_EX_RtAddr_i == IF_ID_RtAddr_i)) ) begin
//         // PC_Stall_o = 1'b1;
//         // IF_ID_Stall_o = 1'b1;
//         stall_o = 1'b1;
//     end

// end
endmodule
