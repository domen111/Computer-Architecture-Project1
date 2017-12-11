EX_MEM EX_MEM(
    clk_i                 (clk_i),
    rst_i                 (rst_i),
    
    ALU_Res_i      [31:0] (ALU.data_o),
    ALU_Res_o      [31:0] (),
    Write_Data_i          (mux7.data_o),
    Write_Data_o          (),
    RdAddr_i       [31:0] (mux8.data_o),
    RdAddr_o       [31:0] (),

    MemToReg_i            (ID_EX.MemToReg_o),
    RegWrite_i            (ID_EX.RegWrite_o),
    MemWrite_i            (ID_EX.MemWrite_o),
    ExtOp_i               (ID_EX.ExtOp_o),
    MemToReg_o            (),
    RegWrite_o            (),
    MemWrite_o            (),
    ExtOp_o               (),
);

// --------- MEM stage [begin] --------- //
Data_Memory Data_Memory(
    clk_i      (clk_i),
    addr_i     (EX_MEM.ALU_Res_o),
    memRead_i  (!EX_MEM.memWrite_i),
    memWrite_i (EX_MEM.memWrite_i),
    wData_i    (EX_MEM.Write_Data_o),
    rData_o    ()
);
// --------- [end] MEM stage --------- //
