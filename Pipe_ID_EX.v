module ID_EX
(
    // Inputs
    input clk_i,
    input rst_i,
    input flush_i,
    input stall_i,
    
    // Pipe in/out
    input      [31:0] pc_i,
    output reg [31:0] pc_o,
    input      [31:0] data1_i,
    output reg [31:0] data1_o,
    input      [31:0] data2_i,
    output reg [31:0] data2_o,
    input      [31:0] sign_extended_i,
    output reg [31:0] sign_extended_o,
    input      [31:0] instruction_i,
    output reg [31:0] instruction_o,
    input             WB_i,
    output reg        WB_o,
    input             M_i,
    output reg        M_o,
    input             EX_i,
    output reg        EX_o
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        instruction_o <= 0;
        pc_o <= 0;
    end
    else begin
        if( !stall_i ) begin
            if( flush_i ) begin
                instruction_o <= 0;
                pc_o <= 0;
            end
            else begin
                pc_o <= pc_i;
                data1_o <= data1_i;
                data2_o <= data2_i;
                sign_extended_o <= sign_extended_i;
                instruction_o <= instruction_i;
                WB_o <= WB_i;
                M_o <= M_i;
                EX_o <= EX_i;
            end
        end
    end
end

endmodule
