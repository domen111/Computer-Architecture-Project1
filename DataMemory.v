module dm
(
    input wire          clk,
    input wire	[6:0]   addr,
    input wire          MemRead,
    input wire          MemWrite,
    input wire 	[31:0]  wdata,
    output wire	[31:0]  rdata
);

// Memories
reg [31:0] mem [0:127];

always @(posedge clk) begin
	if( MemWrite ) begin
        mem[addr] <= wdata;
	end
end

assign rdata = MemRead ? mem[addr][31:0]: wdata;

endmodule
