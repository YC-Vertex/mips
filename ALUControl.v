module ALUControl(
    input [3:0] ALUOp,
    input [5:0] FuncCode,
    output reg [3:0] ALUCtl
);

    always @ (*) begin
        if (ALUOp[3]) begin // R-type
            case (FuncCode)
                6'b10_0000: ALUCtl <= 4'b0010; // add
                6'b10_0010: ALUCtl <= 4'b0110; // sub
                6'b10_0100: ALUCtl <= 4'b0000; // and
                6'b10_0101: ALUCtl <= 4'b0001; // or
                6'b10_1010: ALUCtl <= 4'b0111; // slt
                6'b10_0110: ALUCtl <= 4'b1011; // xor
                6'b00_0000: ALUCtl <= 4'b1001; // sll
                6'b00_0010: ALUCtl <= 4'b1010; // srl
                default: ALUCtl <= 4'b1111;
            endcase
        end
        else begin
            case (ALUOp)
                4'b0001: ALUCtl <= 4'b0010; // addi addiu beq bne
                4'b0010: ALUCtl <= 4'b0000; // andi
                4'b0011: ALUCtl <= 4'b0001; // ori
                4'b0101: ALUCtl <= 4'b1011; // xori
                4'b0111: ALUCtl <= 4'b1000; // lui
                default: ALUCtl <= 4'b1111;
            endcase
        end
    end

endmodule