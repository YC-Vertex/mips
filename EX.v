module EX(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire	[31:0]	i_EX_data_RSData,
	input	wire	[4:0]	i_EX_data_RSAddr,
	input	wire	[4:0]	i_EX_data_RTAddr,
	input	wire	[4:0]	i_EX_data_RDAddr,
	input	wire	[31:0]	i_EX_data_ExtImm,
	input	wire	[4:0]	i_EX_data_Shamt,
	input	wire	[5:0]	i_EX_data_Funct,
	input	wire	[3:0]	i_EX_ctrl_ALUOp,
	input	wire			i_EX_ctrl_ALUSrc,
	input	wire			i_EX_ctrl_RegDst,
	/* --- output --- */
	output	wire	[31:0]	o_MEM_data_ALUOut,
	output	wire			o_MEM_data_Overflow,
	output	wire	[4:0]	o_WB_data_RegAddrW,
	/* --- bypass --- */
	input	wire	[31:0]	i_MEM_data_RTData,
	output	wire	[31:0]	o_MEM_data_RTData,
	input	wire			i_MEM_ctrl_MemWrite,
	output	wire			o_MEM_ctrl_MemWrite,
	input	wire			i_MEM_ctrl_MemRead,
	output	wire			o_MEM_ctrl_MemRead,
	input	wire			i_WB_ctrl_Mem2Reg,
	output	wire			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	wire			o_WB_ctrl_RegWrite
);

    wire [31:0] ExtImm;
    assign ExtImm = i_EX_data_ExtImm;

    wire [31:0] A;
    wire [31:0] B;
    assign A = i_EX_data_RSData;
    assign B = i_EX_ctrl_ALUSrc ? ExtImm : i_MEM_data_RTData;

    wire [3:0] ALUOp;
    wire [4:0] shamt;
    wire [5:0] funct;
    assign ALUOp = i_EX_ctrl_ALUOp;
    assign shamt = i_EX_data_Shamt;
    assign funct = i_EX_data_Funct;

    wire [3:0] ALUCtrl;
    ALUControl alu_control(
        .ALUOp(ALUOp), .FuncCode(funct),
        .ALUCtl(ALUCtrl)
    );

    wire [31:0] ALUOut;
    wire Zero, Overflow;
    ALU alu(
        .ALUCtl(ALUCtrl),
        .A(A), .B(B), .Shamt(shamt),
        .ALUOut(ALUOut),
        .Overflow(Overflow)
    );

	/* Output Assignment Begin */
	assign o_MEM_data_ALUOut = ALUOut;
	assign o_MEM_data_Overflow = Overflow;
    assign o_WB_data_RegAddrW = i_EX_ctrl_RegDst ? i_EX_data_RDAddr : i_EX_data_RTAddr;
	/* Output Assignment End */

	/* Bypass Assignment Begin */
	assign o_MEM_data_RTData = i_MEM_data_RTData;
	assign o_MEM_ctrl_MemWrite = i_MEM_ctrl_MemWrite;
	assign o_MEM_ctrl_MemRead = i_MEM_ctrl_MemRead;
	assign o_WB_ctrl_Mem2Reg = i_WB_ctrl_Mem2Reg;
	assign o_WB_ctrl_RegWrite = i_WB_ctrl_RegWrite;
	/* Bypass Assignment End */

endmodule
