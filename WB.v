module WB(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire			i_WB_ctrl_Mem2Reg,
	input	wire			i_WB_ctrl_RegWrite,
	input	wire	[4:0]	i_WB_data_RegAddrW,
	input	wire	[31:0]	i_WB_data_MemData,
	input	wire	[31:0]	i_WB_data_ALUData,
	/* --- output --- */
	output	wire	[4:0]	o_WB_reg_RegAddrW,
	output	wire	[31:0]	o_WB_reg_RegDataW,
	output	wire			o_WB_reg_RegWrite
	/* --- bypass --- */
	
);

	/* Output Assignment Begin */
    assign o_WB_reg_RegAddrW = i_WB_data_RegAddrW;
    assign o_WB_reg_RegDataW = 
        i_WB_ctrl_Mem2Reg ? i_WB_data_MemData : i_WB_data_ALUData;
    assign o_WB_reg_RegWrite = i_WB_ctrl_RegWrite;    
	/* Output Assignment End */

endmodule
