module Data_Memory
(
    input wire          clk_i,
    input wire	[31:0]   addr_i,
    input wire          memRead_i,
    input wire          memWrite_i,
    input wire 	[31:0]  Write_Data_i,
    output wire	[31:0]  Read_Data_o
);

// Memories
reg [31:0] memory [0:255];

always @(posedge clk_i) begin
	if( memWrite_i ) begin
        memory[addr_i] <= Write_Data_i;
	end
end

assign Read_Data_o = memRead_i ? memory[addr_i][31:0]: Write_Data_i;

endmodule
