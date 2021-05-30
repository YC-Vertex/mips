module MEM_WB_Reg(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	
	/* --- output --- */
	
	/* --- bypass --- */
	input	wire			i_WB_ctrl_Mem2Reg,
	output	reg 			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	reg 			o_WB_ctrl_RegWrite,
	input	wire	[4:0]	i_WB_data_RegAddrW,
	output	reg 	[4:0]	o_WB_data_RegAddrW,
	input	wire	[31:0]	i_WB_data_MemData,
	output	reg 	[31:0]	o_WB_data_MemData,
	input	wire	[31:0]	i_WB_data_ALUData,
	output	reg 	[31:0]	o_WB_data_ALUData
);

	always @ (posedge clk or negedge nrst) begin
		if (~nrst) begin
			o_WB_ctrl_Mem2Reg <= 1'd0;
			o_WB_ctrl_RegWrite <= 1'd0;
			o_WB_data_RegAddrW <= 32'd0;
			// o_WB_data_MemData <= 32'd0;
			o_WB_data_ALUData <= 32'd0;
		end
		else begin
			o_WB_ctrl_Mem2Reg <= i_WB_ctrl_Mem2Reg;
			o_WB_ctrl_RegWrite <= i_WB_ctrl_RegWrite;
			o_WB_data_RegAddrW <= i_WB_data_RegAddrW;
			// o_WB_data_MemData <= i_WB_data_MemData;
			o_WB_data_ALUData <= i_WB_data_ALUData;
		end
	end

	always @ (*) begin
		o_WB_data_MemData = i_WB_data_MemData;
	end

endmodule
