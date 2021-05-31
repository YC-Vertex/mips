module EX_MEM_Reg(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	input	wire	stall,
	input	wire	bubble,
	/* --- bypass --- */
	input	wire	[31:0]	i_MEM_data_RTData,
	output	reg 	[31:0]	o_MEM_data_RTData,
	input	wire			i_MEM_ctrl_MemWrite,
	output	reg 			o_MEM_ctrl_MemWrite,
	input	wire			i_MEM_ctrl_MemRead,
	output	reg 			o_MEM_ctrl_MemRead,
	input	wire			i_WB_ctrl_Mem2Reg,
	output	reg 			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	reg 			o_WB_ctrl_RegWrite,
	input	wire	[31:0]	i_MEM_data_ALUOut,
	output	reg 	[31:0]	o_MEM_data_ALUOut,
	input	wire			i_MEM_data_Overflow,
	output	reg 			o_MEM_data_Overflow,
	input	wire	[4:0]	i_WB_data_RegAddrW,
	output	reg 	[4:0]	o_WB_data_RegAddrW
);

	always @ (posedge clk or negedge nrst) begin
		if (~nrst) begin
			o_MEM_data_RTData <= 32'd0;
			o_MEM_ctrl_MemWrite <= 1'd0;
			o_MEM_ctrl_MemRead <= 1'd0;
			o_WB_ctrl_Mem2Reg <= 1'd0;
			o_WB_ctrl_RegWrite <= 1'd0;
			o_MEM_data_ALUOut <= 32'd0;
			o_MEM_data_Overflow <= 1'd0;
			o_WB_data_RegAddrW <= 5'd0;
		end
		else begin
			if (~stall) begin
				if (bubble) begin
					o_MEM_data_RTData <= 32'd0;
					o_MEM_ctrl_MemWrite <= 1'd0;
					o_MEM_ctrl_MemRead <= 1'd0;
					o_WB_ctrl_Mem2Reg <= 1'd0;
					o_WB_ctrl_RegWrite <= 1'd0;
					o_MEM_data_ALUOut <= 32'd0;
					o_MEM_data_Overflow <= 1'd0;
					o_WB_data_RegAddrW <= 5'd0;
				end
				else begin
					o_MEM_data_RTData <= i_MEM_data_RTData;
					o_MEM_ctrl_MemWrite <= i_MEM_ctrl_MemWrite;
					o_MEM_ctrl_MemRead <= i_MEM_ctrl_MemRead;
					o_WB_ctrl_Mem2Reg <= i_WB_ctrl_Mem2Reg;
					o_WB_ctrl_RegWrite <= i_WB_ctrl_RegWrite;
					o_MEM_data_ALUOut <= i_MEM_data_ALUOut;
					o_MEM_data_Overflow <= i_MEM_data_Overflow;
					o_WB_data_RegAddrW <= i_WB_data_RegAddrW;
				end
			end
		end
	end

endmodule