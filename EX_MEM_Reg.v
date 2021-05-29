module EX_MEM_Reg(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	
	/* --- output --- */
	
	/* --- bypass --- */
	input	wire	[31:0]	i_MEM_data_RTData,
	output	wire	[31:0]	o_MEM_data_RTData,
	input	wire			i_MEM_ctrl_MemWrite,
	output	wire			o_MEM_ctrl_MemWrite,
	input	wire			i_MEM_ctrl_MemRead,
	output	wire			o_MEM_ctrl_MemRead,
	input	wire			i_MEM_ctrl_Branch,
	output	wire			o_MEM_ctrl_Branch,
	input	wire			i_WB_ctrl_Mem2Reg,
	output	wire			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	wire			o_WB_ctrl_RegWrite,
	input	wire	[31:0]	i_MEM_data_PCBranch,
	output	wire	[31:0]	o_MEM_data_PCBranch,
	input	wire	[31:0]	i_MEM_data_ALUOut,
	output	wire	[31:0]	o_MEM_data_ALUOut,
	input	wire			i_MEM_data_Zero,
	output	wire			o_MEM_data_Zero,
	input	wire			i_MEM_data_Overflow,
	output	wire			o_MEM_data_Overflow,
	input	wire	[31:0]	i_WB_data_RegAddrW,
	output	wire	[31:0]	o_WB_data_RegAddrW
);

	always @ (posedge clk or negedge nrst) begin
		if (~nrst) begin
			o_MEM_data_RTData <= 32'd0;
			o_MEM_ctrl_MemWrite <= 1'd0;
			o_MEM_ctrl_MemRead <= 1'd0;
			o_MEM_ctrl_Branch <= 1'd0;
			o_WB_ctrl_Mem2Reg <= 1'd0;
			o_WB_ctrl_RegWrite <= 1'd0;
			o_MEM_data_PCBranch <= 32'd0;
			o_MEM_data_ALUOut <= 32'd0;
			o_MEM_data_Zero <= 1'd0;
			o_MEM_data_Overflow <= 1'd0;
			o_WB_data_RegAddrW <= 32'd0;
		end
		else begin
			o_MEM_data_RTData <= i_MEM_data_RTData;
			o_MEM_ctrl_MemWrite <= i_MEM_ctrl_MemWrite;
			o_MEM_ctrl_MemRead <= i_MEM_ctrl_MemRead;
			o_MEM_ctrl_Branch <= i_MEM_ctrl_Branch;
			o_WB_ctrl_Mem2Reg <= i_WB_ctrl_Mem2Reg;
			o_WB_ctrl_RegWrite <= i_WB_ctrl_RegWrite;
			o_MEM_data_PCBranch <= i_MEM_data_PCBranch;
			o_MEM_data_ALUOut <= i_MEM_data_ALUOut;
			o_MEM_data_Zero <= i_MEM_data_Zero;
			o_MEM_data_Overflow <= i_MEM_data_Overflow;
			o_WB_data_RegAddrW <= i_WB_data_RegAddrW;
		end
	end

endmodule
