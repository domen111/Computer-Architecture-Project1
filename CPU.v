module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input        clk_i;
input        rst_i;
input        start_i;

wire  [31:0] pc;
wire  [31:0] inst;

// --------- IF stage [begin] --------- //
Adder Add_PC(
    .data1_in   (pc),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),
    .pc_o       (pc)
);
Instruction_Memory Instruction_Memory(
    .addr_i     (pc), 
    .instr_o    ()
);
// --------- [end] IF stage --------- //

IF_ID Pipe_IF_ID(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .flush_i       (1'd0),
    .stall_i       (1'd0),
    .imembubble_i  (1'd0),

    .pc_i          (pc),
    .pc_o          (),
    .instruction_i (Instruction_Memory.instr_o),
    .instruction_o (inst),
    .imembubble_o  ()
);

// --------- ID stage [begin] --------- //
Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o ()
);
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o),
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o),
    .RSdata_o   (),
    .RTdata_o   ()
);
MUX5 MUX_RegDst(
    .data0_i    (inst[20:16]),
    .data1_i    (inst[15:11]),
    .select_i   (Control.RegDst_o),
    .data_o     (Registers.RDaddr_i)
);
MUX32 MUX_ALUSrc(
    .data0_i    (Registers.RTdata_o),
    .data1_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (ALU.data2_i)
);
Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX_ALUSrc.data1_i)
);
// --------- [end] ID stage --------- //

ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule

