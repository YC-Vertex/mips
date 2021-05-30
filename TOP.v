module TOP(
    input   wire    clk,
    input   wire    nrst
);

    wire	[31:0]	IF_PCNext_o;
    wire	[31:0]	IF_instruction_o;
    wire			IF_PCSrc_i;
    wire	[31:0]	IF_PCBranch_i;
    // IF external signal (connected to Memory or Register File)
    wire	[31:0]	IF_ImemAddr_o;
    wire	[31:0]	IF_ImemDataR_i;


    wire	[31:0]	ID_PCNext_i;
    wire	[31:0]	ID_PCNext_o;
    wire	[31:0]	ID_instruction_i;
    wire	[31:0]	ID_RSData_o;
    wire	[31:0]	ID_RTData_o;
    wire	[4:0]	ID_RTAddr_o;
    wire	[4:0]	ID_RDAddr_o;
    wire	[31:0]	ID_ExtImm_o;
    wire	[4:0]	ID_Shamt_o;
    wire	[5:0]	ID_Funct_o;
    wire	[3:0]	ID_ALUOp_o;
    wire			ID_ALUSrc_o;
    wire			ID_RegDst_o;
    wire			ID_MemWrite_o;
    wire			ID_MemRead_o;
    wire			ID_Branch_o;
    wire			ID_Mem2Reg_o;
    wire			ID_RegWrite_o;
    // ID external signal (connected to Memory or Register File)
    wire	[4:0]	ID_RegAddr1_o;
    wire	[4:0]	ID_RegAddr2_o;
    wire	[31:0]	ID_RegData1_i;
    wire	[31:0]	ID_RegData2_i;


    wire	[31:0]	EX_PCNext_i;
    wire	[31:0]	EX_RSData_i;
    wire	[31:0]	EX_RTData_i;
    wire	[31:0]	EX_RTData_o;
    wire	[4:0]	EX_RTAddr_i;
    wire	[4:0]	EX_RDAddr_i;
    wire	[31:0]	EX_ExtImm_i;
    wire	[4:0]	EX_Shamt_i;
    wire	[5:0]	EX_Funct_i;
    wire	[3:0]	EX_ALUOp_i;
    wire			EX_ALUSrc_i;
    wire			EX_RegDst_i;
    wire			EX_MemWrite_i;
    wire			EX_MemWrite_o;
    wire			EX_MemRead_i;
    wire			EX_MemRead_o;
    wire			EX_Branch_i;
    wire			EX_Branch_o;
    wire			EX_Mem2Reg_i;
    wire			EX_Mem2Reg_o;
    wire			EX_RegWrite_i;
    wire			EX_RegWrite_o;
    wire	[31:0]	EX_PCBranch_o;
    wire	[31:0]	EX_ALUOut_o;
    wire			EX_Zero_o;
    wire			EX_Overflow_o;
    wire	[4:0]	EX_RegAddrW_o;
    // EX external signal (connected to Memory or Register File)


    wire	[31:0]	MEM_RTData_i;
    wire			MEM_MemWrite_i;
    wire			MEM_MemRead_i;
    wire			MEM_Branch_i;
    wire			MEM_Mem2Reg_i;
    wire			MEM_Mem2Reg_o;
    wire			MEM_RegWrite_i;
    wire			MEM_RegWrite_o;
    wire	[31:0]	MEM_PCBranch_i;
    wire	[31:0]	MEM_ALUOut_i;
    wire			MEM_Zero_i;
    wire			MEM_Overflow_i;
    wire	[4:0]	MEM_RegAddrW_i;
    wire	[4:0]	MEM_RegAddrW_o;
    wire	[31:0]	MEM_MemData_o;
    wire	[31:0]	MEM_ALUData_o;
    wire			MEM_PCSrc_o; assign IF_PCSrc_i = MEM_PCSrc_o;
    wire	[31:0]	MEM_PCBranch_o; assign IF_PCBranch_i = MEM_PCBranch_o;
    // MEM external signal (connected to Memory or Register File)
    wire	[31:0]	MEM_DmemAddr_o;
    wire	[31:0]	MEM_DmemDataW_o;
    wire	[31:0]	MEM_DmemDataR_i;
    wire			MEM_MemRead_o;
    wire			MEM_MemWrite_o;


    wire			WB_Mem2Reg_i;
    wire			WB_RegWrite_i;
    wire	[4:0]	WB_RegAddrW_i;
    wire	[31:0]	WB_MemData_i;
    wire	[31:0]	WB_ALUData_i;
    // WB external signal (connected to Memory or Register File)
    wire	[4:0]	WB_RegAddrW_o;
    wire	[31:0]	WB_RegDataW_o;
    wire			WB_RegWrite_o;


    IF if_(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        .i_IF_ctrl_PCSrc(IF_PCSrc_i),
        .i_IF_data_PCBranch(IF_PCBranch_i),
        .i_IF_mem_ImemDataR(IF_ImemDataR_i),
        /* --- output --- */
        .o_EX_data_PCNext(IF_PCNext_o),
        .o_ID_data_instruction(IF_instruction_o),
        .o_IF_mem_ImemAddr(IF_ImemAddr_o)
        /* --- bypass --- */
    );

    IF_ID_Reg if_id_reg(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        /* --- output --- */
        /* --- bypass --- */
        .i_EX_data_PCNext(IF_PCNext_o),
        .o_EX_data_PCNext(ID_PCNext_i),
        .i_ID_data_instruction(IF_instruction_o),
        .o_ID_data_instruction(ID_instruction_i)
    );

    ID id(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        .i_ID_data_instruction(ID_instruction_i),
        .i_ID_reg_RegData1(ID_RegData1_i),
        .i_ID_reg_RegData2(ID_RegData2_i),
        /* --- output --- */
        .o_EX_data_RSData(ID_RSData_o),
        .o_MEM_data_RTData(ID_RTData_o),
        .o_EX_data_RTAddr(ID_RTAddr_o),
        .o_EX_data_RDAddr(ID_RDAddr_o),
        .o_EX_data_ExtImm(ID_ExtImm_o),
        .o_EX_data_Shamt(ID_Shamt_o),
        .o_EX_data_Funct(ID_Funct_o),
        .o_EX_ctrl_ALUOp(ID_ALUOp_o),
        .o_EX_ctrl_ALUSrc(ID_ALUSrc_o),
        .o_EX_ctrl_RegDst(ID_RegDst_o),
        .o_MEM_ctrl_MemWrite(ID_MemWrite_o),
        .o_MEM_ctrl_MemRead(ID_MemRead_o),
        .o_MEM_ctrl_Branch(ID_Branch_o),
        .o_WB_ctrl_Mem2Reg(ID_Mem2Reg_o),
        .o_WB_ctrl_RegWrite(ID_RegWrite_o),
        .o_ID_reg_RegAddr1(ID_RegAddr1_o),
        .o_ID_reg_RegAddr2(ID_RegAddr2_o),
        /* --- bypass --- */
        .i_EX_data_PCNext(ID_PCNext_i),
        .o_EX_data_PCNext(ID_PCNext_o)
    );

    ID_EX_Reg id_ex_reg(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        /* --- output --- */
        /* --- bypass --- */
        .i_EX_data_PCNext(ID_PCNext_o),
        .o_EX_data_PCNext(EX_PCNext_i),
        .i_EX_data_RSData(ID_RSData_o),
        .o_EX_data_RSData(EX_RSData_i),
        .i_MEM_data_RTData(ID_RTData_o),
        .o_MEM_data_RTData(EX_RTData_i),
        .i_EX_data_RTAddr(ID_RTAddr_o),
        .o_EX_data_RTAddr(EX_RTAddr_i),
        .i_EX_data_RDAddr(ID_RDAddr_o),
        .o_EX_data_RDAddr(EX_RDAddr_i),
        .i_EX_data_ExtImm(ID_ExtImm_o),
        .o_EX_data_ExtImm(EX_ExtImm_i),
        .i_EX_data_Shamt(ID_Shamt_o),
        .o_EX_data_Shamt(EX_Shamt_i),
        .i_EX_data_Funct(ID_Funct_o),
        .o_EX_data_Funct(EX_Funct_i),
        .i_EX_ctrl_ALUOp(ID_ALUOp_o),
        .o_EX_ctrl_ALUOp(EX_ALUOp_i),
        .i_EX_ctrl_ALUSrc(ID_ALUSrc_o),
        .o_EX_ctrl_ALUSrc(EX_ALUSrc_i),
        .i_EX_ctrl_RegDst(ID_RegDst_o),
        .o_EX_ctrl_RegDst(EX_RegDst_i),
        .i_MEM_ctrl_MemWrite(ID_MemWrite_o),
        .o_MEM_ctrl_MemWrite(EX_MemWrite_i),
        .i_MEM_ctrl_MemRead(ID_MemRead_o),
        .o_MEM_ctrl_MemRead(EX_MemRead_i),
        .i_MEM_ctrl_Branch(ID_Branch_o),
        .o_MEM_ctrl_Branch(EX_Branch_i),
        .i_WB_ctrl_Mem2Reg(ID_Mem2Reg_o),
        .o_WB_ctrl_Mem2Reg(EX_Mem2Reg_i),
        .i_WB_ctrl_RegWrite(ID_RegWrite_o),
        .o_WB_ctrl_RegWrite(EX_RegWrite_i)
    );

    EX ex(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        .i_EX_data_PCNext(EX_PCNext_i),
        .i_EX_data_RSData(EX_RSData_i),
        .i_EX_data_RTAddr(EX_RTAddr_i),
        .i_EX_data_RDAddr(EX_RDAddr_i),
        .i_EX_data_ExtImm(EX_ExtImm_i),
        .i_EX_data_Shamt(EX_Shamt_i),
        .i_EX_data_Funct(EX_Funct_i),
        .i_EX_ctrl_ALUOp(EX_ALUOp_i),
        .i_EX_ctrl_ALUSrc(EX_ALUSrc_i),
        .i_EX_ctrl_RegDst(EX_RegDst_i),
        /* --- output --- */
        .o_MEM_data_PCBranch(EX_PCBranch_o),
        .o_MEM_data_ALUOut(EX_ALUOut_o),
        .o_MEM_data_Zero(EX_Zero_o),
        .o_MEM_data_Overflow(EX_Overflow_o),
        .o_WB_data_RegAddrW(EX_RegAddrW_o),
        /* --- bypass --- */
        .i_MEM_data_RTData(EX_RTData_i),
        .o_MEM_data_RTData(EX_RTData_o),
        .i_MEM_ctrl_MemWrite(EX_MemWrite_i),
        .o_MEM_ctrl_MemWrite(EX_MemWrite_o),
        .i_MEM_ctrl_MemRead(EX_MemRead_i),
        .o_MEM_ctrl_MemRead(EX_MemRead_o),
        .i_MEM_ctrl_Branch(EX_Branch_i),
        .o_MEM_ctrl_Branch(EX_Branch_o),
        .i_WB_ctrl_Mem2Reg(EX_Mem2Reg_i),
        .o_WB_ctrl_Mem2Reg(EX_Mem2Reg_o),
        .i_WB_ctrl_RegWrite(EX_RegWrite_i),
        .o_WB_ctrl_RegWrite(EX_RegWrite_o)
    );

    EX_MEM_Reg ex_mem_reg(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        /* --- output --- */
        /* --- bypass --- */
        .i_MEM_data_RTData(EX_RTData_o),
        .o_MEM_data_RTData(MEM_RTData_i),
        .i_MEM_ctrl_MemWrite(EX_MemWrite_o),
        .o_MEM_ctrl_MemWrite(MEM_MemWrite_i),
        .i_MEM_ctrl_MemRead(EX_MemRead_o),
        .o_MEM_ctrl_MemRead(MEM_MemRead_i),
        .i_MEM_ctrl_Branch(EX_Branch_o),
        .o_MEM_ctrl_Branch(MEM_Branch_i),
        .i_WB_ctrl_Mem2Reg(EX_Mem2Reg_o),
        .o_WB_ctrl_Mem2Reg(MEM_Mem2Reg_i),
        .i_WB_ctrl_RegWrite(EX_RegWrite_o),
        .o_WB_ctrl_RegWrite(MEM_RegWrite_i),
        .i_MEM_data_PCBranch(EX_PCBranch_o),
        .o_MEM_data_PCBranch(MEM_PCBranch_i),
        .i_MEM_data_ALUOut(EX_ALUOut_o),
        .o_MEM_data_ALUOut(MEM_ALUOut_i),
        .i_MEM_data_Zero(EX_Zero_o),
        .o_MEM_data_Zero(MEM_Zero_i),
        .i_MEM_data_Overflow(EX_Overflow_o),
        .o_MEM_data_Overflow(MEM_Overflow_i),
        .i_WB_data_RegAddrW(EX_RegAddrW_o),
        .o_WB_data_RegAddrW(MEM_RegAddrW_i)
    );

    MEM mem(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        .i_MEM_data_RTData(MEM_RTData_i),
        .i_MEM_ctrl_MemWrite(MEM_MemWrite_i),
        .i_MEM_ctrl_MemRead(MEM_MemRead_i),
        .i_MEM_ctrl_Branch(MEM_Branch_i),
        .i_MEM_data_PCBranch(MEM_PCBranch_i),
        .i_MEM_data_ALUOut(MEM_ALUOut_i),
        .i_MEM_data_Zero(MEM_Zero_i),
        .i_MEM_data_Overflow(MEM_Overflow_i),
        .i_MEM_mem_DmemDataR(MEM_DmemDataR_i),
        /* --- output --- */
        .o_WB_data_MemData(MEM_MemData_o),
        .o_WB_data_ALUData(MEM_ALUData_o),
        .o_IF_ctrl_PCSrc(MEM_PCSrc_o),
        .o_IF_data_PCBranch(MEM_PCBranch_o),
        .o_MEM_mem_DmemAddr(MEM_DmemAddr_o),
        .o_MEM_mem_DmemDataW(MEM_DmemDataW_o),
        .o_MEM_mem_MemRead(MEM_MemRead_o),
        .o_MEM_mem_MemWrite(MEM_MemWrite_o),
        /* --- bypass --- */
        .i_WB_ctrl_Mem2Reg(MEM_Mem2Reg_i),
        .o_WB_ctrl_Mem2Reg(MEM_Mem2Reg_o),
        .i_WB_ctrl_RegWrite(MEM_RegWrite_i),
        .o_WB_ctrl_RegWrite(MEM_RegWrite_o),
        .i_WB_data_RegAddrW(MEM_RegAddrW_i),
        .o_WB_data_RegAddrW(MEM_RegAddrW_o)
    );

    MEM_WB_Reg mem_wb_reg(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        /* --- output --- */
        /* --- bypass --- */
        .i_WB_ctrl_Mem2Reg(MEM_Mem2Reg_o),
        .o_WB_ctrl_Mem2Reg(WB_Mem2Reg_i),
        .i_WB_ctrl_RegWrite(MEM_RegWrite_o),
        .o_WB_ctrl_RegWrite(WB_RegWrite_i),
        .i_WB_data_RegAddrW(MEM_RegAddrW_o),
        .o_WB_data_RegAddrW(WB_RegAddrW_i),
        .i_WB_data_MemData(MEM_MemData_o),
        .o_WB_data_MemData(WB_MemData_i),
        .i_WB_data_ALUData(MEM_ALUData_o),
        .o_WB_data_ALUData(WB_ALUData_i)
    );

    WB wb(
        .clk(clk), .nrst(nrst),
        /* --- input --- */
        .i_WB_ctrl_Mem2Reg(WB_Mem2Reg_i),
        .i_WB_ctrl_RegWrite(WB_RegWrite_i),
        .i_WB_data_RegAddrW(WB_RegAddrW_i),
        .i_WB_data_MemData(WB_MemData_i),
        .i_WB_data_ALUData(WB_ALUData_i),
        /* --- output --- */
        .o_WB_reg_RegAddrW(WB_RegAddrW_o),
        .o_WB_reg_RegDataW(WB_RegDataW_o),
        .o_WB_reg_RegWrite(WB_RegWrite_o)
        /* --- bypass --- */
    );

    Memory #("data/imem.hex") imem(
        .clk(clk), .nrst(nrst),
        .CEN(1'b1),
        .WEN(1'b0),
        .A(IF_ImemAddr_o),
        .D(32'h0),
        .Q(IF_ImemDataR_i)
    );

    Memory #("data/dmem.hex") dmem(
        .clk(clk), .nrst(nrst),
        .CEN(1'b1),
        .WEN(MEM_MemWrite_o),
        .A(MEM_DmemAddr_o),
        .D(MEM_DmemDataW_o),
        .Q(MEM_DmemDataR_i)
    );

    RegFile regfile(
        .CLK(clk), .RST(nrst),
        .RegWre(WB_RegWrite_o),
        .ReadReg1(ID_RegAddr1_o),
        .ReadReg2(ID_RegAddr2_o),
        .ReadData1(ID_RegData1_i),
        .ReadData2(ID_RegData2_i),
        .WriteReg(WB_RegAddrW_o),
        .WriteData(WB_RegDataW_o)
    );

endmodule