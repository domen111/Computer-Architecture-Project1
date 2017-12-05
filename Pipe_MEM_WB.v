module MEM_WB
(
    // Inputs
    input clk_i,
    input rst_i,
    input flush_i,      // Flush (lowest priority)
    input stall_i,      // Stall (2nd highest priority)
    
    // Pipe in/out
    input      [31:0] pc_i,
    output reg [31:0] pc_o,
    input      [31:0] ALU_Res_i,
    output reg [31:0] ALU_Res_o,
    input      [31:0] Read_Data_i,
    output reg [31:0] Read_Data_o,
    input      [3:0]  Forward_Data_i,
    output reg [3:0]  Forward_Data_o,
    input             WB_i,
    output reg        WB_o
);

// Asynchronous output driver
always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        // Initialize outputs to 0s
        pc_o <= 0;
    end
    else begin
        if( !stall_i ) begin
            if( flush_i ) begin
                // Pass through all 0s
                pc_o <= 0;
            end
            else begin
                // Pass through signals
                pc_o <= pc_i;
                ALU_Res_o <= ALU_Res_i;
                Read_Data_o <= Read_Data_i;
                Forward_Data_o <= Forward_Data_i;
                WB_o <= WB_i;
            end
        end
    end
end

endmodule
