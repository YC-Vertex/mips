module IF(
	/* --- global ---*/
	input	wire	clk,
	input	wire	nrst,
    input   wire    stall,
	/* --- input --- */
	input	wire			i_IF_ctrl_PCSrc,
	input	wire	[31:0]	i_IF_data_PCBranch,
	input	wire	[31:0]	i_IF_mem_ImemDataR,
	/* --- output --- */
	output	wire	[31:0]	o_EX_data_PCNext,
	output	wire	[31:0]	o_ID_data_instruction,
	output	wire	[31:0]	o_IF_mem_ImemAddr
	/* --- bypass --- */

);

    // parameter MIPS_START_ADDR = 32'h4001fffc;
    parameter MIPS_START_ADDR = 32'h0;

    reg [31:0] PC;
    wire [31:0] PCNext;
    wire [31:0] PCBranch;
    wire PCSrc;
    assign PCNext = PC + 32'd4;
    assign PCBranch = i_IF_data_PCBranch;
    assign PCSrc = i_IF_ctrl_PCSrc;

    always @ (posedge clk or negedge nrst) begin
        if (~nrst) begin
            PC <= MIPS_START_ADDR;
        end
        else begin
            if (stall)
                PC <= PC;
            else begin
                if (PCSrc)
                    PC <= PCBranch;
                else
                    PC <= PCNext;
            end
        end
    end

	/* Output Assignment Begin */
	assign o_EX_data_PCNext = PCNext;
	assign o_ID_data_instruction = i_IF_mem_ImemDataR;
	assign o_IF_mem_ImemAddr = PC;
	/* Output Assignment End */

endmodule
