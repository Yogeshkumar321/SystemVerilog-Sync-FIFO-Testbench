module fifo #(
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3, 
    parameter DATA_WIDTH = 8
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  full,
    output logic                  empty
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  
    logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

   
    logic [ADDR_WIDTH:0] fifo_counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wdata;
            wr_ptr <= wr_ptr + 1;
        end
    end

   
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rdata  <= '0;
        end else if (rd_en && !empty) begin
            rdata <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            fifo_counter <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_counter <= fifo_counter + 1; // Write only
                2'b01: fifo_counter <= fifo_counter - 1; // Read only
                default: fifo_counter <= fifo_counter;   // No change or simultaneous
            endcase
        end
    end

    // Full and Empty flags
    assign full  = (fifo_counter == DEPTH);
    assign empty = (fifo_counter == 0);

endmodule
