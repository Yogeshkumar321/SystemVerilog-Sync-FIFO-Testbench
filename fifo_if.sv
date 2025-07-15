interface fifo_if(input logic clk);
    logic rd;
    logic rst;
    logic wr;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic full, empty;

    clocking driver_cb @(posedge clk);
        default input #1 output #1;
        output rst;
        output data_in;
        output rd;
        output wr;
        input full;
        input empty;
        input data_out;
    endclocking

    clocking monitor @(posedge clk);
        input rst;
        input rd;
        input wr;
        input data_in;
        input data_out;
        input full, empty;
    endclocking

    modport DRIVER (clocking driver_cb, input clk);
    modport MONITOR (clocking monitor, input clk);
endinterface