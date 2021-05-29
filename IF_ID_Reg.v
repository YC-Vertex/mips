module IF_ID_Reg(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	
	/* --- output --- */
	
	/* --- bypass --- */
	input	wire	[31:0]	i_EX_data_PCNext,
	output	wire	[31:0]	o_EX_data_PCNext,
	input	wire	[31:0]	i_ID_data_instruction,
	output	wire	[31:0]	o_ID_data_instruction
);

	always @ (posedge clk or negedge nrst) begin
		if (~nrst) begin
			o_EX_data_PCNext <= 32'd0;
			o_ID_data_instruction <= 32'd0;
		end
		else begin
			o_EX_data_PCNext <= i_EX_data_PCNext;
			o_ID_data_instruction <= i_ID_data_instruction;
		end
	end

endmodule