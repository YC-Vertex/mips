module ID_EX_Reg(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	input	wire	stall,
	input	wire	bubble,
	/* --- bypass --- */
	input	wire	[31:0]	i_EX_data_PCNext,
	output	reg 	[31:0]	o_EX_data_PCNext,
	input	wire	[31:0]	i_EX_data_RSData,
	output	reg 	[31:0]	o_EX_data_RSData,
	input	wire	[31:0]	i_MEM_data_RTData,
	output	reg 	[31:0]	o_MEM_data_RTData,
	input	wire	[4:0]	i_EX_data_RSAddr,
	output	reg 	[4:0]	o_EX_data_RSAddr,
	input	wire	[4:0]	i_EX_data_RTAddr,
	output	reg 	[4:0]	o_EX_data_RTAddr,
	input	wire	[4:0]	i_EX_data_RDAddr,
	output	reg 	[4:0]	o_EX_data_RDAddr,
	input	wire	[31:0]	i_EX_data_ExtImm,
	output	reg 	[31:0]	o_EX_data_ExtImm,
	input	wire	[4:0]	i_EX_data_Shamt,
	output	reg 	[4:0]	o_EX_data_Shamt,
	input	wire	[5:0]	i_EX_data_Funct,
	output	reg 	[5:0]	o_EX_data_Funct,
	input	wire	[3:0]	i_EX_ctrl_ALUOp,
	output	reg 	[3:0]	o_EX_ctrl_ALUOp,
	input	wire			i_EX_ctrl_ALUSrc,
	output	reg 			o_EX_ctrl_ALUSrc,
	input	wire			i_EX_ctrl_RegDst,
	output	reg 			o_EX_ctrl_RegDst,
	input	wire	[1:0]	i_EX_ctrl_Jump,
	output	reg 	[1:0]	o_EX_ctrl_Jump,
	input	wire	[1:0]	i_EX_ctrl_Branch,
	output	reg 	[1:0]	o_EX_ctrl_Branch,
	input	wire			i_MEM_ctrl_MemWrite,
	output	reg 			o_MEM_ctrl_MemWrite,
	input	wire			i_MEM_ctrl_MemRead,
	output	reg 			o_MEM_ctrl_MemRead,
	input	wire			i_WB_ctrl_Mem2Reg,
	output	reg 			o_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	output	reg 			o_WB_ctrl_RegWrite
);

	always @ (posedge clk or negedge nrst) begin
		if (~nrst) begin
			o_EX_data_PCNext <= 32'd0;
			o_EX_data_RSData <= 32'd0;
			o_MEM_data_RTData <= 32'd0;
			o_EX_data_RSAddr <= 5'd0;
			o_EX_data_RTAddr <= 5'd0;
			o_EX_data_RDAddr <= 5'd0;
			o_EX_data_ExtImm <= 32'd0;
			o_EX_data_Shamt <= 5'd0;
			o_EX_data_Funct <= 6'd0;
			o_EX_ctrl_ALUOp <= 4'd0;
			o_EX_ctrl_ALUSrc <= 1'd0;
			o_EX_ctrl_RegDst <= 1'd0;
			o_EX_ctrl_Jump <= 2'd0;
			o_EX_ctrl_Branch <= 2'd0;
			o_MEM_ctrl_MemWrite <= 1'd0;
			o_MEM_ctrl_MemRead <= 1'd0;
			o_WB_ctrl_Mem2Reg <= 1'd0;
			o_WB_ctrl_RegWrite <= 1'd0;
		end
		else begin
			if (~stall) begin
				if (bubble) begin
					o_EX_data_PCNext <= 32'd0;
					o_EX_data_RSData <= 32'd0;
					o_MEM_data_RTData <= 32'd0;
					o_EX_data_RSAddr <= 5'd0;
					o_EX_data_RTAddr <= 5'd0;
					o_EX_data_RDAddr <= 5'd0;
					o_EX_data_ExtImm <= 32'd0;
					o_EX_data_Shamt <= 5'd0;
					o_EX_data_Funct <= 6'd0;
					o_EX_ctrl_ALUOp <= 4'd0;
					o_EX_ctrl_ALUSrc <= 1'd0;
					o_EX_ctrl_RegDst <= 1'd0;
					o_EX_ctrl_Jump <= 2'd0;
					o_EX_ctrl_Branch <= 2'd0;
					o_MEM_ctrl_MemWrite <= 1'd0;
					o_MEM_ctrl_MemRead <= 1'd0;
					o_WB_ctrl_Mem2Reg <= 1'd0;
					o_WB_ctrl_RegWrite <= 1'd0;
				end
				else begin
					o_EX_data_PCNext <= i_EX_data_PCNext;
					o_EX_data_RSData <= i_EX_data_RSData;
					o_MEM_data_RTData <= i_MEM_data_RTData;
					o_EX_data_RSAddr <= i_EX_data_RSAddr;
					o_EX_data_RTAddr <= i_EX_data_RTAddr;
					o_EX_data_RDAddr <= i_EX_data_RDAddr;
					o_EX_data_ExtImm <= i_EX_data_ExtImm;
					o_EX_data_Shamt <= i_EX_data_Shamt;
					o_EX_data_Funct <= i_EX_data_Funct;
					o_EX_ctrl_ALUOp <= i_EX_ctrl_ALUOp;
					o_EX_ctrl_ALUSrc <= i_EX_ctrl_ALUSrc;
					o_EX_ctrl_RegDst <= i_EX_ctrl_RegDst;
					o_EX_ctrl_Jump <= i_EX_ctrl_Jump;
					o_EX_ctrl_Branch <= i_EX_ctrl_Branch;
					o_MEM_ctrl_MemWrite <= i_MEM_ctrl_MemWrite;
					o_MEM_ctrl_MemRead <= i_MEM_ctrl_MemRead;
					o_WB_ctrl_Mem2Reg <= i_WB_ctrl_Mem2Reg;
					o_WB_ctrl_RegWrite <= i_WB_ctrl_RegWrite;
				end
			end
		end
	end

endmodule