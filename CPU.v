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
    .Flush_o    ()
);

Mux32 mux1(
    .data0_i    (Add_PC.data_o),
    .data1_i    (ADD.data_o),
    .select_i   (Branch_And.Branch_o),
    .data_o     ()
);

Branch_And Branch_And(
    .Branch_i   (Control.Branch_o),
    .Equal_i    (Equal.Equal_o),
    .Branch_o   ()
);

Mux32 mux2(
    .data0_i    (mux1.data_o),
    .data1_i    ({mux1.data_o[31:28], ShiftLeft2.data_o}),
    .select_i   (Control.Jump_o),
    .data_o     ()
);

Adder Add_PC(
    .data1_i    (pc),
    .data2_i    (32'd4),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (Hazard_Detection_Unit.stall_o),
    .memStall_i (dcache_top.p1_stall_o),
    .pc_i       (mux2.data_o),
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc),
    .instr_o    ()
);
// --------- [end] IF stage --------- //

IF_ID IF_ID(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .flush_i        (IF_ID_Flush.Flush_o),
    .stall_i        (Hazard_Detection_Unit.stall_o),
    .memStall_i     (dcache_top.p1_stall_o),
    .pc_i           (Add_PC.data_o),
    .pc_o           (),
    .instruction_i  (Instruction_Memory.instr_o),
    .instruction_o  (inst)
);

// --------- ID stage [begin] --------- //
Hazard_Detection_Unit Hazard_Detection_Unit(
    .ID_EX_MemRead_i    (ID_EX.MemRead_o),
    .IF_ID_RsAddr_i     (inst[25:21]),
    .IF_ID_RtAddr_i     (inst[20:16]),
    .ID_EX_RtAddr_i     (ID_EX.instruction_o[20:16]),
    .stall_o            ()
);

ShiftLeft2 ShiftLeft2(
    .data_i (inst[25:0]),
    .data_o ()
);

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemToReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .MemRead_o (),
    .Branch_o   (),
    .Jump_o     (),
    .ExtOp_o    (),
    .ALUOp_o    ()
);

MuxControl mux8
(
    .stall_i    (Hazard_Detection_Unit.stall_o),
    .RegDst_i   (Control.RegDst_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .MemToReg_i (Control.MemToReg_o),
    .RegWrite_i (Control.RegWrite_o),
    .MemWrite_i (Control.MemWrite_o),
    .MemRead_i  (Control.MemRead_o),
    .Branch_i   (Control.Branch_o),
    .Jump_i     (Control.Jump_o),
    .ExtOp_i    (Control.ExtOp_o),
    .ALUOp_i    (Control.ALUOp_o),
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemToReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .MemRead_o  (),
    .Branch_o   (),
    .Jump_o     (),
    .ExtOp_o    (),
    .ALUOp_o    ()
);

Adder ADD(
    .data1_i   (Sign_Extend.data_o << 2),
    .data2_i   (IF_ID.pc_o),
    .data_o     ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MEM_WB.RdAddr_o),
    .RDdata_i   (mux5.data_o),
    .RegWrite_i (MEM_WB.RegWrite_o),
    .RSdata_o   (),
    .RTdata_o   ()
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()
);

Equal Equal(
    .RSData_i   (Registers.RSdata_o),
    .RTData_i   (Registers.RTdata_o),
    .Equal_o    ()
);
// --------- [end] ID stage --------- //

ID_EX ID_EX(
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .memStall_i         (dcache_top.p1_stall_o),
    
    .pc_i               (IF_ID.pc_o),
    .pc_o               (),
    .data1_i            (Registers.RSdata_o),
    .data1_o            (),
    .data2_i            (Registers.RTdata_o),
    .data2_o            (),
    .sign_extended_i    (Sign_Extend.data_o),
    .sign_extended_o    (),
    .instruction_i      (inst),
    .instruction_o      (),

    // Control Outputs
    .RegDst_i        (mux8.RegDst_o),
    .ALUSrc_i        (mux8.ALUSrc_o),
    .MemToReg_i      (mux8.MemToReg_o),
    .RegWrite_i      (mux8.RegWrite_o),
    .MemWrite_i      (mux8.MemWrite_o),
    .MemRead_i       (mux8.MemRead_i),
    .ExtOp_i         (mux8.ExtOp_o),
    .ALUOp_i         (mux8.ALUOp_o),
    .RegDst_o        (),
    .ALUSrc_o        (),
    .MemToReg_o      (),
    .RegWrite_o      (),
    .MemWrite_o      (),
    .MemRead_o       (),
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
    .ID_EX_RsAddr_i     (ID_EX.instruction_o[25:21]),
    .ID_EX_RtAddr_i     (ID_EX.instruction_o[20:16]),
    .EX_MEM_RegWrite_i  (EX_MEM.RegWrite_o),
    .EX_MEM_RdAddr_i    (EX_MEM.RdAddr_o),
    .MEM_WB_RegWrite_i  (MEM_WB.RegWrite_o),
    .MEM_WB_RdAddr_i    (MEM_WB.RdAddr_o),
    .EX_RsOverride_o    (),
    .EX_RtOverride_o    ()
);
ALU_Control ALU_Control(
    .funct_i    (ID_EX.instruction_o[5:0]),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  ()
);
ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);
Mux5 mux3(
    .data0_i    (ID_EX.instruction_o[20:16]),
    .data1_i    (ID_EX.instruction_o[15:11]),
    .select_i   (ID_EX.RegDst_o),
    .data_o     ()
);
// --------- [end] EX stage --------- //

EX_MEM EX_MEM(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .memStall_i     (dcache_top.p1_stall_o),    
    
    .ALU_Res_i      (ALU.data_o),
    .ALU_Res_o      (),
    .Write_Data_i   (mux7.data_o),
    .Write_Data_o   (),
    .RdAddr_i       (mux3.data_o),
    .RdAddr_o       (),

    .MemToReg_i     (ID_EX.MemToReg_o),
    .RegWrite_i     (ID_EX.RegWrite_o),
    .MemWrite_i     (ID_EX.MemWrite_o),
    .MemRead_i      (ID_EX.MemRead_o),
    .ExtOp_i        (ID_EX.ExtOp_o),
    .MemToReg_o     (),
    .RegWrite_o     (),
    .MemWrite_o     (),
    .MemRead_o      (),
    .ExtOp_o        ()
);

// --------- MEM stage [begin] --------- //
Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .addr_i         (dcache_top.mem_addr_o),
    .data_i         (dcache_top.mem_data_o),
    .enable_i       (dcache_top.mem_enable_o),
    .write_i        (dcache_top.mem_write_o),
    .ack_o          (),
    .data_o         ()
);

dcache_top dcache_top(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .mem_data_i     (Data_Memory.data_o),
    .mem_ack_i      (Data_Memory.ack_o),
    .mem_data_o     (),
    .mem_addr_o     (),
    .mem_enable_o   (),
    .mem_write_o    (),
    .p1_data_i      (EX_MEM.Write_Data_o),
    .p1_addr_i      (EX_MEM.ALU_Res_o),
    .p1_MemRead_i   (EX_MEM.MemRead_o),
    .p1_MemWrite_i  (EX_MEM.MemWrite_o),
    .p1_data_o      (),
    .p1_stall_o     ()
);
// --------- [end] MEM stage --------- //

MEM_WB MEM_WB(
    // Inputs
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .memStall_i (dcache_top.p1_stall_o),    
    
    // Pipe in/out
    .ALU_Res_i  (EX_MEM.ALU_Res_o),
    .ALU_Res_o  (),
    .Read_Data_i(Data_Memory.data_o),
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

// always @(*) begin
//     $display("Forwarding_Unit.EX_RtOverride_o: %d, ID_EX.instruction_o: %d, EX_MEM.RegWrite_o: %d, EX_MEM.RdAddr_o:%d, MEM_WB.RegWrite_o: %d, MEM_WB.RdAddr_o:%d, ALU.data1_i:%d, ALU.data2_i:%d, mux4.data1_i:%d, rst_i: %d, ALU.data_o: %d",
//               Forwarding_Unit.EX_RtOverride_o,     ID_EX.instruction_o,     EX_MEM.RegWrite_o,     EX_MEM.RdAddr_o   , MEM_WB.RegWrite_o    , MEM_WB.RdAddr_o   , ALU.data1_i   , ALU.data2_i   , mux4.data1_i   , rst_i    , ALU.data_o);
// end

endmodule

