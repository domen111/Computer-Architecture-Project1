module Data_Memory
(
    input wire          clk_i,
    input wire	[6:0]   addr_i,
    input wire          memRead_i,
    input wire          memWrite_i,
    input wire 	[31:0]  wData_i,
    output wire	[31:0]  rData_o
);

// Memories
reg [31:0] mem [0:127];

always @(posedge clk_i) begin
	if( memWrite_i ) begin
        mem[addr_i] <= wData_i;
	end
end

assign rData_o = memRead_i ? mem[addr_i][31:0]: wData_i;

endmodule
