module RegFile(
    input CLK,
    input RST,
    input RegWre,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    input   wire            RSFwd,
    input   wire            RTFwd,
    input   wire    [31:0]  DataFwd
);

    reg [31:0] regFile[1:31];
    integer i;
    assign ReadData1 = RSFwd ? DataFwd :
        (ReadReg1==5'b0) ? 32'b0 : 
        (RegWre && ReadReg1==WriteReg) ? WriteData : regFile[ReadReg1]; // bypass RS
    assign ReadData2 = RTFwd ? DataFwd :
        (ReadReg2==5'b0) ? 32'b0 : 
        (RegWre && ReadReg2==WriteReg) ? WriteData : regFile[ReadReg2]; // bypass RT

    always@(posedge CLK or negedge RST)
    begin
        if(!RST)
        begin
            for(i=1;i<32;i=i+1)
            regFile[i]<=32'b0;
        end
        else if(RegWre&(WriteReg!=5'b0))
        regFile[WriteReg]<=WriteData;
    end

endmodule