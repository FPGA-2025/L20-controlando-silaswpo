module fifo (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output wire full,
    output wire empty,
    output reg [3:0] fifo_words
);

    reg [7:0] mem [0:7];
    reg [2:0] w_ptr;
    reg [2:0] r_ptr;

    assign full = (fifo_words == 8);
    assign empty = (fifo_words == 0);

    always @(posedge clk) begin
        if (!rst_n) begin
            w_ptr <= 0;
            fifo_words <= 0;
        end else if (wr_en && !full) begin
            mem[w_ptr] <= data_in;
            w_ptr <= w_ptr + 1;
            if (!rd_en || empty)  // Se não houve leitura no mesmo ciclo
                fifo_words <= fifo_words + 1;
        end else if (rd_en && !empty && !wr_en) begin
            fifo_words <= fifo_words - 1;
        end
    end

    always @(posedge clk) begin
        if (!rst_n)
            r_ptr <= 0;
        else if (rd_en && !empty)
            r_ptr <= r_ptr + 1;
    end

    always @(posedge clk) begin
        if (rd_en && !empty)
            data_out <= mem[r_ptr];
    end

endmodule
