module ID(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire	[31:0]	i_ID_data_PCNext,
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
	output	wire			o_MEM_ctrl_MemWrite,
	output	wire			o_MEM_ctrl_MemRead,
	output	wire			o_WB_ctrl_Mem2Reg,
	output	wire			o_WB_ctrl_RegWrite,
	output	wire			o_IF_ctrl_PCSrc,
	output	wire	[31:0]	o_IF_data_PCBranch,
	output	wire	[4:0]	o_ID_reg_RegAddr1,
	output	wire	[4:0]	o_ID_reg_RegAddr2
);

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

	wire [3:0] ALUOp;
    wire ALUSrc, RegDst, MemWrite, MemRead, Mem2Reg, RegWrite;
	wire Br, Eq, Jp;
    Control control(
        .Op(OP),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),.RegDst(RegDst),
        .MemWrite(MemWrite), .MemRead(MemRead),
        .MemtoReg(Mem2Reg), .RegWrite(RegWrite),
		.Branch(Br), .Beq(Eq), .Jump(Jp)
    );

	wire [31:0] RSData;
	wire [31:0] RTData;
	assign RSData = i_ID_reg_RegData1;
	assign RTData = i_ID_reg_RegData2;
	wire [31:0] ExtImm;
	assign ExtImm = {{16{IMM[15]}}, IMM};
	wire [31:0] PCNext;
	assign PCNext = i_ID_data_PCNext;

	reg PCSrc;
	reg [31:0] PCBranch;
	always @ (*) begin
		PCSrc = 1'b0;
		PCBranch = 32'hx;
		if (Br & ~Jp) begin
			if ((RSData == RTData) == Eq) begin
				PCBranch = PCNext + (ExtImm << 2);
				PCSrc = 1'b1;
			end
		end
		else if (~Br & Jp) begin
			PCBranch = {PCNext[31:28], INSTR[25:0], 2'b00};
			PCSrc = 1'b1;
		end
	end

	/* Output Assignment Begin */
    assign o_EX_data_RSData = RSData;
    assign o_MEM_data_RTData = RTData;
    assign o_EX_data_RSAddr = RS;
    assign o_EX_data_RTAddr = RT;
    assign o_EX_data_RDAddr = RD;
    assign o_EX_data_ExtImm = ExtImm;
    assign o_EX_data_Shamt = SHAMT;
    assign o_EX_data_Funct = FUNCT;
    assign o_EX_ctrl_ALUOp = ALUOp;
    assign o_EX_ctrl_ALUSrc = ALUSrc;
    assign o_EX_ctrl_RegDst = RegDst;
    assign o_MEM_ctrl_MemWrite = MemWrite;
    assign o_MEM_ctrl_MemRead = MemRead;
    assign o_WB_ctrl_Mem2Reg = Mem2Reg;
    assign o_WB_ctrl_RegWrite = RegWrite;
	assign o_IF_ctrl_PCSrc = PCSrc;
	assign o_IF_data_PCBranch = PCBranch;
	assign o_ID_reg_RegAddr1 = INSTR[25:21];
	assign o_ID_reg_RegAddr2 = INSTR[20:16];
	/* Output Assignment End */

endmodule
