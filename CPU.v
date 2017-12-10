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

IF_ID IF_ID(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .flush_i       (1'd0),
    .stall_i       (1'd0),
    // .imembubble_i  (1'd0),

    .pc_i          (pc),
    .pc_o          (),
    .instruction_i (Instruction_Memory.instr_o),
    .instruction_o (inst)
    // .imembubble_o  ()
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
Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()
);
Mux10 mux8(
    .data0_i    (),
    .data1_i    (),
    .select_i   (),
    .data_o     ()
);
// --------- [end] ID stage --------- //

ID_EX ID_EX(
    .clk_i           (clk_i),
    .rst_i           (rst_i),
    .flush_i         (1'd0),
    .stall_i         (1'd0),

    .pc_i            (IF_ID.pc_o),
    .pc_o            (),
    .data1_i         (Registers.data1_o),
    .data1_o         (mux6.data0_i),
    .data2_i         (Registers.data2_o),
    .data2_o         (mux7.data0_i),
    .sign_extended_i (Sign_Extend.data_o),
    .sign_extended_o (),
    .instruction_i   (inst),
    .instruction_o   (),
    .WB_i            (),
    .WB_o            (),
    .M_i             (),
    .M_o             (),
    .EX_i            (),
    .EX_o            ()
);

// --------- EX stage [begin] --------- //
Mux32 mux6(
    .data0_i    (ID_EX.data1_o),
    .data1_i    (/*todo*/),
    .select_i   (),
    .data_o     ()
);
Mux32 mux7(
    .data0_i    (),
    .data1_i    (),
    .select_i   (),
    .data_o     ()
);
Mux32 mux4(
    .data0_i    (),
    .data1_i    (),
    .select_i   (),
    .data_o     ()
);
ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);
ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);
// --------- [end] EX stage --------- //

endmodule

