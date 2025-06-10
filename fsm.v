module fsm (
    input wire clk,
    input wire rst_n,
    output reg wr_en,
    output wire [7:0] fifo_data,
    input wire [3:0] fifo_words
);

    localparam WRITE = 1'b0, WAIT = 1'b1;
    reg state, next_state;

    assign fifo_data = 8'hAA;

    // Transição de estado
    always @(posedge clk) begin
        if (!rst_n)
            state <= WRITE;
        else
            state <= next_state;
    end

    // Lógica de próxima transição
    always @(*) begin
        case (state)
            WRITE: next_state = (fifo_words == 5) ? WAIT : WRITE;
            WAIT:  next_state = (fifo_words <= 2) ? WRITE : WAIT;
            default: next_state = WRITE;
        endcase
    end

    // Saída de controle
    always @(*) begin
        wr_en = (state == WRITE);
    end

endmodule
