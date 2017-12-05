module EX_MEM
(
    // Inputs
    input clk_i,
    input rst_i,
    input flush_i,
    input stall_i,
    
    // Pipe in/out
    input      [31:0] pc_i,
    output reg [31:0] pc_o,
    input      [31:0] ALU_Res_i,
    output reg [31:0] ALU_Res_o,
    input             Write_Data_i,
    output reg        Write_Data_o,
    input      [3:0]  Forward_Data_i,
    output reg [3:0]  Forward_Data_o,
    input             WB_i,
    output reg        WB_o,
    input             M_i,
    output reg        M_o
);

always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        pc_o <= 0;
    end
    else begin
        if( !stall_i ) begin
            if( flush_i ) begin
                pc_o <= 0;
            end
            else begin
                pc_o <= pc_i;
                ALU_Res_o <= ALU_Res_i;
                Write_Data_o <= Write_Data_i;
                Forward_Data_o <= Forward_Data_i;
                WB_o <= WB_i;
                M_o <= M_i;
            end
        end
    end
end

endmodule
