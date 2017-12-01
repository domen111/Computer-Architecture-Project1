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

wire  [31:0] inst_addr;
wire  [31:0] inst;
wire  [31:0] alu_out;
wire         Control_RegDst;
wire  [1:0]  Control_ALUOp;
wire         Control_ALUSrc;
wire         Control_RegWrite;
wire  [31:0] PC_i;
wire  [31:0] Registers_RSdata;
wire  [31:0] Registers_RTdata;
wire  [31:0] ALU_data2;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (Control_RegDst),
    .ALUOp_o    (Control_ALUOp),
    .ALUSrc_o   (Control_ALUSrc),
    .RegWrite_o (Control_RegWrite)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (PC_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (PC_i),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o), 
    .RDdata_i   (alu_out),
    .RegWrite_i (Control_RegWrite), 
    .RSdata_o   (Registers_RSdata), 
    .RTdata_o   (Registers_RTdata) 
);

MUX5 MUX_RegDst(
    .data0_i    (inst[20:16]),
    .data1_i    (inst[15:11]),
    .select_i   (Control_RegDst),
    .data_o     (Registers.RDaddr_i)
);

MUX32 MUX_ALUSrc(
    .data0_i    (Registers_RTdata),
    .data1_i    (Sign_Extend.data_o),
    .select_i   (Control_ALUSrc),
    .data_o     (ALU_data2)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX_ALUSrc.data1_i)
);
  
ALU ALU(
    .data1_i    (Registers_RSdata),
    .data2_i    (ALU_data2),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (alu_out),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control_ALUOp),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule

