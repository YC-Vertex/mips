module EX(
	/* --- global --- */
	input	wire	clk,
	input	wire	nrst,
	/* --- input --- */
	input	wire	[31:0]	i_EX_data_PCNext,
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
	input	wire	[1:0]	i_EX_ctrl_Jump,
	input	wire	[1:0]	i_EX_ctrl_Branch,
	/* --- output --- */
	output	wire	[31:0]	o_MEM_data_ALUOut,
	output	wire			o_MEM_data_Overflow,
	output	wire	[4:0]	o_WB_data_RegAddrW,
	output	wire			o_IF_ctrl_PCSrc,
	output	wire	[31:0]	o_IF_data_PCBranch,
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

	localparam BEQ = 2'b01;
	localparam BNE = 2'b10;
	localparam J   = 2'b01;
	localparam JAL = 2'b10;
	localparam JR  = 2'b11;

	wire [1:0] Jp;
	wire [1:0] Br;
	assign Jp = i_EX_ctrl_Jump;
	assign Br = i_EX_ctrl_Branch;

	wire [31:0] PCNext;
	wire [31:0] ExtImm;
	assign PCNext = i_EX_data_PCNext;
	assign ExtImm = i_EX_data_ExtImm;

    wire [31:0] A;
    wire [31:0] B;
    assign A = (Br != 2'b0) ? PCNext : i_EX_data_RSData;
    assign B = (Br != 2'b0) ? (ExtImm << 2) : i_EX_ctrl_ALUSrc ? ExtImm : i_MEM_data_RTData;

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

	wire [31:0] RSData;
	wire [31:0] RTData;
	wire [25:0] JpAddr;
	assign RSData = i_EX_data_RSData;
	assign RTData = i_MEM_data_RTData;
	assign JpAddr = {i_EX_data_RSAddr, i_EX_data_RTAddr, ExtImm[15:0]};

	reg PCSrc;
	reg [31:0] PCBranch;
	always @ (*) begin
		PCSrc = 1'b0;
		PCBranch = 32'hx;
		// Branch: beq, bne
		if (Br != 2'b0 && Jp == 2'b0) begin
			if ((RSData == RTData) == (Br == BEQ)) begin
				PCBranch = ALUOut;
				PCSrc = 1'b1;
			end
		end
		// Jump: j, jr, jal
		else if (Br == 2'b0 && Jp != 2'b0) begin
			if (Jp == JR)
				PCBranch = RSData;
			else
				PCBranch = {PCNext[31:28], JpAddr, 2'b00};
			PCSrc = 1'b1;
		end
	end

	/* Output Assignment Begin */
	assign o_MEM_data_ALUOut = (Jp == JAL) ? PCNext : ALUOut;
	assign o_MEM_data_Overflow = Overflow;
    assign o_WB_data_RegAddrW = (Jp == JAL) ? 5'd31 :
		i_EX_ctrl_RegDst ? i_EX_data_RDAddr : i_EX_data_RTAddr;
	assign o_IF_ctrl_PCSrc = PCSrc;
	assign o_IF_data_PCBranch = PCBranch;
	/* Output Assignment End */

	/* Bypass Assignment Begin */
	assign o_MEM_data_RTData = i_MEM_data_RTData;
	assign o_MEM_ctrl_MemWrite = i_MEM_ctrl_MemWrite;
	assign o_MEM_ctrl_MemRead = i_MEM_ctrl_MemRead;
	assign o_WB_ctrl_Mem2Reg = i_WB_ctrl_Mem2Reg;
	assign o_WB_ctrl_RegWrite = i_WB_ctrl_RegWrite;
	/* Bypass Assignment End */

endmodule
