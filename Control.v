module Control(
    input [5:0] Op,
    output reg [3:0] ALUOp,
    output reg ALUSrc,RegDst,MemWrite,MemRead,RegWrite,MemtoReg,
    output reg [1:0] Jump,
    output reg [1:0] Branch
);

	localparam BEQ = 2'b01;
	localparam BNE = 2'b10;
	localparam J   = 2'b01;
	localparam JAL = 2'b10;
	localparam JR  = 2'b11;

    always @ (*) begin
        RegDst  <= 1'b0;
        ALUSrc  <= 1'b0;
        MemtoReg<= 1'b0;
        RegWrite<= 1'b0;
        MemRead <= 1'b0;
        MemWrite<= 1'b0;
        ALUOp   <= 4'b0000;
        Jump    <= 2'b0;
        Branch  <= 2'b0;

        case (Op)
            6'b000000: begin // R-type
                RegDst  <= 1'b1;
                ALUSrc  <= 1'b0;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b1000;
            end

            6'b000010: begin // j
                Jump <= J;
            end
            6'b000011: begin // jal
                Jump <= JAL;
                RegWrite<= 1'b1;
            end
            6'b000100: begin // beq
                Branch <= BEQ;
                ALUOp   <= 4'b0001;
            end
            6'b000101: begin // bne
                Branch <= BNE;
                ALUOp   <= 4'b0001;
            end

            6'b001000: begin // addi
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0001;
            end
            6'b001001: begin // addiu
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0001;
            end
            6'b001100: begin // andi
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0010;
            end
            6'b001101: begin // ori
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0011;
            end
            6'b001110: begin // xori
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0101;
            end

            6'b001111: begin // lui
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b0;
                RegWrite<= 1'b1;
                MemRead <= 1'b0;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0111;
            end
            6'b100011: begin // lw
                RegDst  <= 1'b0;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b1;
                RegWrite<= 1'b1;
                MemRead <= 1'b1;
                MemWrite<= 1'b0;
                ALUOp   <= 4'b0001;
            end
            6'b101011: begin // sw
                RegDst  <= 1'b1;
                ALUSrc  <= 1'b1;
                MemtoReg<= 1'b1;
                RegWrite<= 1'b0;
                MemRead <= 1'b0;
                MemWrite<= 1'b1;
                ALUOp   <= 4'b0001;
            end
        endcase
    end

endmodule
