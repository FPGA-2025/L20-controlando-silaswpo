module fifo(
    input clk,
    input rst_n,

    // Interface de escrita
    input wr_en,
    input [7:0] data_in,
    output full,

    // Interface de leitura
    input rd_en,
    output reg [7:0] data_out,
    output empty,

    // Status: quantidade de elementos armazenados
    output reg [3:0] fifo_words
);

    reg [7:0] mem [7:0];       // Memória de 8 posições
    reg [2:0] w_ptr, r_ptr;    // Ponteiros de escrita/leitura

    assign full  = (fifo_words == 8);
    assign empty = (fifo_words == 0);

    always @(posedge clk) begin
        if (!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            fifo_words <= 0;
            data_out <= 0;
        end else begin
            // Escrita (se permitido)
            if (wr_en && !full) begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1;
                fifo_words <= fifo_words + 1;
            end

            // Leitura (se permitido)
            if (rd_en && !empty) begin
                data_out <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                fifo_words <= fifo_words - 1;
            end
        end
    end
endmodule
