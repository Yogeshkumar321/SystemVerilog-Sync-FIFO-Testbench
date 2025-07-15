class driver;
    virtual fifo_if vif_ff;
    mailbox gen2driv;
    int no_of_transactions;

    function new(virtual fifo_if vif_ff, mailbox gen2driv);
        this.vif_ff = vif_ff;
        this.gen2driv = gen2driv;
    endfunction

    task reset();
        $display("entered into reset mode");
        vif_ff.DRIVER.driver_cb.rst <= 1;
        repeat(4) @(posedge vif_ff.DRIVER.clk); // Reset for 40ns (4 cycles at 10ns)
        vif_ff.DRIVER.driver_cb.rst <= 0;
        $display("leaving from reset mode");
    endtask

    task main();
        $display("entered into transaction mode");
        forever begin
            transactor trans;
            gen2driv.get(trans);
            @(posedge vif_ff.DRIVER.clk);
            if (trans.wr || trans.rd) begin
                if (trans.wr) begin
                    vif_ff.DRIVER.driver_cb.wr <= trans.wr;
                    vif_ff.DRIVER.driver_cb.rd <= trans.rd;
                    vif_ff.DRIVER.driver_cb.data_in <= trans.data_in;
                    $display("Time %0t: Driven: wr=%b, rd=%b, data_in=%h", $time, trans.wr, trans.rd, trans.data_in);
                    @(posedge vif_ff.DRIVER.clk); // Hold for one cycle
                    vif_ff.DRIVER.driver_cb.wr <= 0; // Clear wr after one cycle
                end else if (trans.rd) begin
                    vif_ff.DRIVER.driver_cb.wr <= trans.wr;
                    vif_ff.DRIVER.driver_cb.rd <= trans.rd;
                    $display("Time %0t: Driven: wr=%b, rd=%b", $time, trans.wr, trans.rd);
                    @(posedge vif_ff.DRIVER.clk);
                    vif_ff.DRIVER.driver_cb.rd <= 0; // Clear rd after one cycle
                end
            end
            no_of_transactions++;
            $display("no.of.transactions=%d", no_of_transactions);
        end
    endtask
endclass