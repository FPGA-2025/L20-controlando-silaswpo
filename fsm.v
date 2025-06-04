module fsm(
    input wire clk,
    input wire rst_n,
    output reg wr_en,
    output wire [7:0] fifo_data,
    input wire [3:0] fifo_words
);

    // Estados da máquina
    parameter ESCREVENDO = 1'b0;
    parameter ESPERANDO  = 1'b1;

    reg estado;

    assign fifo_data = 8'hAA; // dado constante

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            estado <= ESCREVENDO;
        else begin
            case (estado)
                ESCREVENDO:
                    if (fifo_words >= 5)
                        estado <= ESPERANDO;

                ESPERANDO:
                    if (fifo_words <= 2)
                        estado <= ESCREVENDO;
            endcase
        end
    end

    // Saída: escreve somente se no estado ESCREVENDO
    always @(*) begin
        wr_en = (estado == ESCREVENDO);
    end
endmodule
