module IF_ID
(
    // Inputs
    input clk_i,
    input rst_i,
    input flush_i,      // Flush (lowest priority)
    input stall_i,      // Stall (2nd highest priority)
    // input imembubble_i, // fetched inst is bogus due to icache miss
    
    // Pipe in/out
    input [31:0] pc_i,
    output reg [31:0] pc_o,
    input [31:0] instruction_i,
    output reg [31:0] instruction_o
    // output reg imembubble_o
);

// Asynchronous output driver
always @(posedge clk_i or negedge rst_i) begin
    if( !rst_i ) begin
        // Initialize outputs to 0s
        instruction_o <= 0;
        pc_o <= 0;
    end
    else begin
        if( !stall_i ) begin
            if( flush_i ) begin
                // Pass through all 0s
                instruction_o <= 0;
                pc_o <= 0;
            end
            else begin
                // Pass through signals
                instruction_o <= instruction_i;
                pc_o <= pc_i;
                // imembubble_o <= imembubble_i;
            end
        end
    end
end

endmodule
