module MEM(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire	[31:0]	i_MEM_data_RTData,
	input	wire			i_MEM_ctrl_MemWrite,
	input	wire			i_MEM_ctrl_MemRead,
	input	wire			i_MEM_ctrl_Branch,
	input	wire	[31:0]	i_MEM_data_PCBranch,
	input	wire	[31:0]	i_MEM_data_ALUOut,
	input	wire			i_MEM_data_Zero,
	input	wire			i_MEM_data_Overflow,
	input	wire	[31:0]	i_MEM_mem_DmemDataR,
	/* --- output --- */
	output	wire	[31:0]	o_WB_data_MemData,
	output	wire	[31:0]	o_WB_data_ALUData,
	output	wire			o_IF_ctrl_PCSrc,
	output	wire	[31:0]	o_IF_data_PCBranch,
	output	wire	[31:0]	o_MEM_mem_DmemAddr,
	output	wire	[31:0]	o_MEM_mem_DmemDataW,
	output	wire			o_MEM_mem_MemRead,
	output	wire			o_MEM_mem_MemWrite,
	/* --- bypass --- */
	input	wire			i_WB_ctrl_Mem2Reg,
	output	wire			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	wire			o_WB_ctrl_RegWrite,
	input	wire	[31:0]	i_WB_data_RegAddrW,
	output	wire	[31:0]	o_WB_data_RegAddrW
);

	/* Output Assignment Begin */
    assign o_WB_data_MemData = i_MEM_mem_DmemDataR;
    assign o_WB_data_ALUData = i_MEM_data_ALUOut;
    assign o_IF_ctrl_PCSrc = i_MEM_ctrl_Branch & i_MEM_data_Zero;
    assign o_IF_data_PCBranch = i_MEM_data_PCBranch;
    assign o_MEM_mem_DmemAddr = i_MEM_data_ALUOut;
    assign o_MEM_mem_DmemDataW = i_MEM_data_RTData;
    assign o_MEM_mem_MemRead = i_MEM_ctrl_MemRead;
    assign o_MEM_mem_MemWrite = i_MEM_ctrl_MemWrite;
	/* Output Assignment End */

	/* Bypass Assignment Begin */
	assign o_WB_ctrl_Mem2Reg = i_WB_ctrl_Mem2Reg;
	assign o_WB_ctrl_RegWrite = i_WB_ctrl_RegWrite;
	assign o_WB_data_RegAddrW = i_WB_data_RegAddrW;
	/* Bypass Assignment End */

endmodule
