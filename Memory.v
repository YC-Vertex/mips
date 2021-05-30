module Memory(
    input   wire    clk,
    input   wire    nrst,
    input   wire    CEN,
    input   wire    WEN,
    input   wire    [31:0]  A,
    input   wire    [31:0]  D,
    output  reg     [31:0]  Q
);

    parameter fmem = 0;
    integer i;

    reg [31:0] MEM [0:1023];

    always @ (posedge clk or negedge  nrst) begin
        if (~nrst) begin
            for (i = 0; i < 1024; i = i + 1)
                MEM[i] = 32'h0;
            if (fmem != 0)
                $readmemh(fmem, MEM);
        end

        else begin
            Q <= 32'h0;
            if (CEN) begin
                Q <= MEM[A[11:2]];
                if (WEN) begin
                    MEM[A[11:2]] <= D;
                end
            end
        end
    end

endmodule