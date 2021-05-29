module Control(
    input [5:0] Op,
    output reg [3:0] ALUOp,
    output reg ALUSrc,RegDst,MemWrite,MemRead,RegWrite,MemtoReg,Branch,jump,SignExtend,pcreg
);

    always@(*)
    begin
        case(Op)
            6'd0://R
            begin
                RegDst<=1'b1;
                ALUSrc<=1'b0;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b1000;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;


            end
            6'b100011://lw
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b1;
                RegWrite<=1'b1;
                MemRead<=1'b1;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0000;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;

            end
            6'b101011://sw
            begin
                RegDst<=1'b1;
                ALUSrc<=1'b1;
                MemtoReg<=1'b1;
                RegWrite<=1'b0;
                MemRead<=1'b0;
                MemWrite<=1'b1;
                Branch<=1'b0;
                ALUOp<=4'b0000;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;

            end
            6'b000100://beq
            begin
                RegDst<=1'b1;
                ALUSrc<=1'b0;
                MemtoReg<=1'b1;
                RegWrite<=1'b0;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b1;
                ALUOp<=4'b0100;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;

            end
            6'b000101://bne
            begin
                RegDst<=1'b1;
                ALUSrc<=1'b0;
                MemtoReg<=1'b1;
                RegWrite<=1'b0;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b1;
                ALUOp<=4'b0110;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;
            end
            6'b001000://addi
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0001;
                jump<=1'b0;
                pcreg<=1'b0;
            end
            6'b001001://addiu
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0001;
                jump<=1'b0;
                SignExtend<=1'b0;
                pcreg<=1'b0;
            end
            6'b001100://andi
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0010;
                jump<=1'b0;
                SignExtend<=1'b0;
                pcreg<=1'b0;
                end
            6'b001101://ori
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0011;
                jump<=1'b0;
                SignExtend<=1'b0;
                pcreg<=1'b0;
            end
            6'b001110://xori
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0101;
                jump<=1'b0;
                SignExtend<=1'b0;
                pcreg<=1'b0;
            end
            6'b001111://addi
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0111;
                jump<=1'b0;
                SignExtend<=1'b1;
                pcreg<=1'b0;
            end
            6'b000010://j
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0111;
                jump<=1'b1;
                SignExtend<=1'b1;
                pcreg<=1'b0;
            end
            6'b000011://jal
            begin
                RegDst<=1'b0;
                ALUSrc<=1'b1;
                MemtoReg<=1'b0;
                RegWrite<=1'b1;
                MemRead<=1'b0;
                MemWrite<=1'b0;
                Branch<=1'b0;
                ALUOp<=4'b0111;
                jump<=1'b1;
                SignExtend<=1'b1;
                pcreg<=1'b1;
            end
        endcase
    end

endmodule