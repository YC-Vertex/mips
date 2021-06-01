module Memory(
    input   wire    clk,
    input   wire    nrst,
    input   wire    CEN,
    input   wire    WEN,
    input   wire    [31:0]  A,
    input   wire    [31:0]  D,
    input   wire    Hold,
    input   wire    Flush,
    output  reg     [31:0]  Q
);

    parameter fmem = 0;
    integer i;

    reg [31:0] MEM [0:255];

    always @ (posedge clk or negedge  nrst) begin
        if (~nrst) begin
            for (i = 0; i < 1024; i = i + 1)
                MEM[i] = 32'h0;
            if (fmem != 0)
                $readmemh(fmem, MEM);
        end

        else begin
            Q <= 32'hx;
            if (CEN) begin
                // read
                if (Hold)
                    Q <= Q;
                else if (Flush)
                    Q <= 32'h0;
                else
                    Q <= MEM[A[11:2]];
                // write
                if (WEN)
                    MEM[A[11:2]] <= D;
            end
        end
    end

endmodule