module ID(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire	[31:0]	i_ID_data_instruction,
	input	wire	[31:0]	i_ID_reg_RegData1,
	input	wire	[31:0]	i_ID_reg_RegData2,
	/* --- output --- */
	output	wire	[31:0]	o_EX_data_RSData,
	output	wire	[31:0]	o_MEM_data_RTData,
	output	wire	[4:0]	o_EX_data_RSAddr,
	output	wire	[4:0]	o_EX_data_RTAddr,
	output	wire	[4:0]	o_EX_data_RDAddr,
	output	wire	[31:0]	o_EX_data_ExtImm,
	output	wire	[4:0]	o_EX_data_Shamt,
	output	wire	[5:0]	o_EX_data_Funct,
	output	wire	[3:0]	o_EX_ctrl_ALUOp,
	output	wire			o_EX_ctrl_ALUSrc,
	output	wire			o_EX_ctrl_RegDst,
	output	wire	[1:0]	o_EX_ctrl_Jump,
	output	wire	[1:0]	o_EX_ctrl_Branch,
	output	wire			o_MEM_ctrl_MemWrite,
	output	wire			o_MEM_ctrl_MemRead,
	output	wire			o_WB_ctrl_Mem2Reg,
	output	wire			o_WB_ctrl_RegWrite,
	output	wire	[4:0]	o_ID_reg_RegAddr1,
	output	wire	[4:0]	o_ID_reg_RegAddr2,
	/* --- bypass --- */
	input	wire	[31:0]	i_EX_data_PCNext,
	output	wire	[31:0]	o_EX_data_PCNext
);

	localparam BEQ = 2'b01;
	localparam BNE = 2'b10;
	localparam J   = 2'b01;
	localparam JAL = 2'b10;
	localparam JR  = 2'b11;

    wire [31:0] INSTR;
    assign INSTR = i_ID_data_instruction;
    wire [5:0] OP;
    wire [4:0] SHAMT;
    wire [5:0] FUNCT;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [4:0] RD;
    wire [15:0] IMM;
    assign {OP, RS, RT, RD, SHAMT, FUNCT} = INSTR;
    assign IMM = INSTR[15:0];

	wire Jr;
	wire ZeroExtend;
	assign Jr = (OP == 6'b00_0000) && (FUNCT == 6'b00_1000);
	assign ZeroExtend = (OP == 6'b00_1001) || (OP == 6'b00_1100) || (OP == 6'b001101) || (OP ==6'b001110);

	wire [3:0] ALUOp;
    wire ALUSrc, RegDst, MemWrite, MemRead, Mem2Reg, RegWrite;
	wire [1:0] Jump;
	wire [1:0] Branch;
    Control control(
        .Op(Jr ? 6'b00_0010 : OP),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),.RegDst(RegDst),
        .MemWrite(MemWrite), .MemRead(MemRead),
        .MemtoReg(Mem2Reg), .RegWrite(RegWrite),
		.Jump(Jump), .Branch(Branch)
    );

	/* Output Assignment Begin */
    assign o_EX_data_RSData = i_ID_reg_RegData1;
    assign o_MEM_data_RTData = i_ID_reg_RegData2;
    assign o_EX_data_RSAddr = RS;
    assign o_EX_data_RTAddr = RT;
    assign o_EX_data_RDAddr = RD;
    assign o_EX_data_ExtImm = {ZeroExtend ? 16'b0 : {16{IMM[15]}}, IMM};
    assign o_EX_data_Shamt = SHAMT;
    assign o_EX_data_Funct = FUNCT;
    assign o_EX_ctrl_ALUOp = ALUOp;
    assign o_EX_ctrl_ALUSrc = ALUSrc;
    assign o_EX_ctrl_RegDst = RegDst;
	assign o_EX_ctrl_Jump = Jr ? JR : Jump;
	assign o_EX_ctrl_Branch = Branch;
    assign o_MEM_ctrl_MemWrite = MemWrite;
    assign o_MEM_ctrl_MemRead = MemRead;
    assign o_WB_ctrl_Mem2Reg = Mem2Reg;
    assign o_WB_ctrl_RegWrite = RegWrite;
	assign o_ID_reg_RegAddr1 = INSTR[25:21];
	assign o_ID_reg_RegAddr2 = INSTR[20:16];
	/* Output Assignment End */

	/* Bypass Assignment Begin */
	assign o_EX_data_PCNext = i_EX_data_PCNext;
	/* Bypass Assignment End */

endmodule
