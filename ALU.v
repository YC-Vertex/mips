module ALU(
    input [3:0] ALUCtl,
    input [31:0] A,
    input [31:0] B,
    input [4:0] Shamt,
    output reg [31:0] ALUOut,
    output wire Overflow
);

    wire signed [31:0] A_signed, B_signed;
    assign A_signed = A;
    assign B_signed = B;
    assign Overflow = 
        (ALUCtl == 4'b0010) ? A > ALUOut :
        (ALUCtl == 4'b0110) ? A < B : 1'b0;

    always @ (*)
    begin
        case (ALUCtl)
            4'b0010: ALUOut <= A + B; // add
            4'b0110: ALUOut <= A - B; // sub
            4'b0000: ALUOut <= A & B; // and
            4'b0001: ALUOut <= A | B; // or
            // 4'b1100: ALUOut <= ~(A | B); // nor
            4'b0111: ALUOut <= (A_signed < B_signed) ? 1 : 0; // slt
            4'b1001: ALUOut <= B << Shamt; // sll
            4'b1010: ALUOut <= B >> Shamt; // srl
            4'b1000: ALUOut <= B << 16; // lui
            // 4'b1101: ALUOut <= (A == 0) ? 32'd32 : {27'b0, result}; // clz
            4'b1011: ALUOut <= A ^ B; // xor
            default: ALUOut <= 0;
        endcase
    end

endmodule
