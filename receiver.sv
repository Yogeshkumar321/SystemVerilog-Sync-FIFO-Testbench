class receiver;
    virtual fifo_if vif;
    mailbox rcvr2sb;

    function new(virtual fifo_if vif, mailbox rcvr2sb);
        this.vif = vif;
        this.rcvr2sb = rcvr2sb;
    endfunction

    task start();
        $display("receiver module started");
        forever begin
            transactor trans = new();
            @(posedge vif.MONITOR.clk);
            wait (vif.MONITOR.monitor.rd || vif.MONITOR.monitor.wr);
            @(posedge vif.MONITOR.clk);
            if (vif.MONITOR.monitor.wr) begin
                trans.wr = vif.MONITOR.monitor.wr;
                trans.rd = vif.MONITOR.monitor.rd;
                trans.data_in = vif.MONITOR.monitor.data_in;
                trans.full = vif.MONITOR.monitor.full;
                trans.empty = vif.MONITOR.monitor.empty;
                $display("Time %0t: Received Write: data_in=%h, full=%b, empty=%b", $time, trans.data_in, trans.full, trans.empty);
            end else if (vif.MONITOR.monitor.rd) begin
                trans.rd = vif.MONITOR.monitor.rd;
                trans.wr = vif.MONITOR.monitor.wr;
                trans.data_out = vif.MONITOR.monitor.data_out;
                trans.full = vif.MONITOR.monitor.full;
                trans.empty = vif.MONITOR.monitor.empty;
                $display("Time %0t: Received Read: data_out=%h, full=%b, empty=%b", $time, trans.data_out, trans.full, trans.empty);
            end
            rcvr2sb.put(trans);
        end
    endtask
endclass