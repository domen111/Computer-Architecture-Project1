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
IF_ID_Flush IF_ID_Flush(
    .Jump_i     (Control.Jump_o),
    .Branch_i   (Branch_And.Branch_o),
    .Flush_o    (IF_ID.flush_i)
);

Mux32 mux1(
    .data0_i    (ID_ADD.data_o),
    .data1_i    (Add_PC.data_o),
    .select_i   (Branch_And.Branch_o),
    .data_o     ()
);

Branch_And Branch_And(
    .Branch_i   (Control.Branch_o),
    .Equal_i    (Equal.Equal_o),
    .Branch_o   (mux1.select_i)
);

Mux32 mux2(
    .data0_i    (mux1.data_o),
    .data1_i    (),
    .select_i   (Control.Jump_o),
    .data_o     ()
);

Adder Add_PC(
    .data1_in   (pc),
    .data2_in   (32'd4),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (mux2.data_o),
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc),
    .instr_o    (IF_ID.instruction_i)
);
// --------- [end] IF stage --------- //

IF_ID IF_ID(
    .clk_i         (clk_i),
    .rst_i         (rst_i),
    .flush_i       (),
    .stall_i       (Hazard_Detection_Unit.stall_o),
    // .imembubble_i  (1'd0),

    .pc_i          (pc),
    .pc_o          (),
    .instruction_i (),
    .instruction_o (inst)
    // .imembubble_o  ()
);

// --------- ID stage [begin] --------- //
Hazard_Detection_Unit Hazard_Detection_Unit(
    .ID_EX_MemRead_i    (),
    .IF_ID_RsAddr_i     (),
    .IF_ID_RtAddr_i     (),
    .ID_EX_RtAddr_i     (),
    .PC_Stall_o         (),
    .IF_ID_Stall_o      (),
    .stall_o            ()
);

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemToReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .Branch_o   (),
    .Jump_o     (),
    .ExtOp_o    (),
    .ALUOp_o    ()
);

MuxControl MuxControl
(
    .stall_i    (),
    .RegDst_i   (),
    .ALUSrc_i   (),
    .MemToReg_i (),
    .RegWrite_i (),
    .MemWrite_i (),
    .Branch_i   (),
    .Jump_i     (),
    .ExtOp_i    (),
    .ALUOp_i    (),
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemToReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .Branch_o   (),
    .Jump_o     (),
    .ExtOp_o    (),
    .ALUOp_o    ()
);

Adder ID_ADD(
    .data1_in   (IF_ID.pc_o),
    .data2_in   (),
    .data_o     (mux1.data0_i)
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

Mux5 MUX_RegDst(
    .data0_i    (inst[20:16]),
    .data1_i    (inst[15:11]),
    .select_i   (Control.RegDst_o),
    .data_o     (Registers.RDaddr_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()
);

Equal Equal(
    .RSData_i   (),
    .RTData_i   (),
    .Equal_o    (Branch_And.Equal_i)
);
// --------- [end] ID stage --------- //

ID_EX ID_EX(
    .clk_i           (clk_i),
    .rst_i           (rst_i),
    .flush_i         (1'd0),
    .stall_i         (1'd0),

    .pc_i            (IF_ID.pc_o),
    .pc_o            (),
    .data1_i         (Registers.RSdata_o),
    .data1_o         (mux6.data0_i),
    .data2_i         (Registers.RTdata_o),
    .data2_o         (mux7.data0_i),
    .sign_extended_i (Sign_Extend.data_o),
    .sign_extended_o (),
    .instruction_i   (inst),
    .instruction_o   (),

    // Control Outputs
    .RegDst_i        (Control.RegDst_o),
    .ALUSrc_i        (Control.ALUSrc_o),
    .MemToReg_i      (Control.MemToReg_o),
    .RegWrite_i      (Control.RegWrite_o),
    .MemWrite_i      (Control.MemWrite_o),
    .ExtOp_i         (Control.ExtOp_o),
    .ALUOp_i         (Control.ALUOp_o),
    .RegDst_o        (),
    .ALUSrc_o        (),
    .MemToReg_o      (),
    .RegWrite_o      (),
    .MemWrite_o      (),
    .ExtOp_o         (),
    .ALUOp_o         ()
);

// --------- EX stage [begin] --------- //
Mux32_3 mux6(
    .data0_i    (ID_EX.data1_o),
    .data1_i    (mux5.data_o),
    .data2_i    (EX_MEM.ALU_Res_o),
    .select_i   (Forwarding_Unit.EX_RsOverride_o),
    .data_o     ()
);
Mux32_3 mux7(
    .data0_i    (ID_EX.data2_o),
    .data1_i    (mux5.data_o),
    .data2_i    (EX_MEM.ALU_Res_o),
    .select_i   (Forwarding_Unit.EX_RtOverride_o),
    .data_o     ()
);
Mux32 mux4(
    .data0_i    (mux7.data_o),
    .data1_i    (ID_EX.sign_extended_o),
    .select_i   (ID_EX.ALUSrc_o),
    .data_o     ()
);
Forwarding_Unit Forwarding_Unit(
    .ID_EX_RsAddr_i     (),
    .ID_EX_RtAddr_i     (),
    .EX_MEM_RegWrite_i  (),
    .EX_MEM_RdAddr_i    (),
    .MEM_WB_RegWrite_i  (),
    .MEM_WB_RdAddr_i    (),
    .EX_RsOverride_o    (),
    .EX_RtOverride_o    ()
);
ALU_Control ALU_Control(
    .funct_i    (ID_EX.instruction_o[5:0]),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);
ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (),
    .data_o     (),
    .Zero_o     ()
);
Mux5 mux8(
    .data0_i    (ID_EX.instruction_o[20:16]),
    .data1_i    (ID_EX.instruction_o[15:11]),
    .select_i   (ID_EX.RegDst_o),
    .data_o     ()
);
// --------- [end] EX stage --------- //

EX_MEM EX_MEM(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    
    .ALU_Res_i      (ALU.data_o),
    .ALU_Res_o      (),
    .Write_Data_i   (mux7.data_o),
    .Write_Data_o   (),
    .RdAddr_i       (mux8.data_o),
    .RdAddr_o       (),

    .MemToReg_i     (ID_EX.MemToReg_o),
    .RegWrite_i     (ID_EX.RegWrite_o),
    .MemWrite_i     (ID_EX.MemWrite_o),
    .ExtOp_i        (ID_EX.ExtOp_o),
    .MemToReg_o     (),
    .RegWrite_o     (),
    .MemWrite_o     (),
    .ExtOp_o        (),
);

// --------- MEM stage [begin] --------- //
Data_Memory Data_Memory(
    .clk_i       (clk_i),
    .addr_i      (EX_MEM.ALU_Res_o),
    .memRead_i   (!EX_MEM.MemWrite_o), // weird
    .memWrite_i  (EX_MEM.MemWrite_o),
    .Write_Data_i(EX_MEM.Write_Data_o),
    .Read_Data_o ()
);
// --------- [end] MEM stage --------- //
MEM_WB MEM_WB(
    // Inputs
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    
    // Pipe in/out
    .ALU_Res_i  (EX_MEM.ALU_Res_o),
    .ALU_Res_o  (),
    .Read_Data_i(Data_Memory.Read_Data_o),
    .Read_Data_o(),
    .RdAddr_i   (EX_MEM.RdAddr_o),
    .RdAddr_o   (),
    .MemToReg_i (EX_MEM.MemToReg_o),
    .RegWrite_i (EX_MEM.RegWrite_o),
    .MemToReg_o (),
    .RegWrite_o ()
);
// --------- WB stage [begin] ------- //
Mux32 mux5(
    .data0_i    (MEM_WB.ALU_Res_o),
    .data1_i    (MEM_WB.Read_Data_o),
    .select_i   (MEM_WB.MemToReg_o),
    .data_o     ()
);
// --------- [end] WB stage --------- //
endmodule

