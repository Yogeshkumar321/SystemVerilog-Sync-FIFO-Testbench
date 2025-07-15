module tb_top();
    bit clk;
    fifo_if inf(clk);
    test t1(inf);
    fifo dut(.data_in(inf.data_in), .rd(inf.rd), .wr(inf.wr), .full(inf.full), .empty(inf.empty), .data_out(inf.data_out), .clk(clk), .rst(inf.rst));

    initial begin
        clk = 1;
        $display("Simulation started at %0t", $time);
    end

    always #5 clk = ~clk; // 10ns period

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule