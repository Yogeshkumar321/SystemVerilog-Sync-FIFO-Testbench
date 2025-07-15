class environment;
    generator gen;
    driver driv;
    receiver rcv;
    scoreboard sb;
    mailbox gen2driv;
    mailbox exp2sb;
    mailbox rcv2sb;
    virtual fifo_if vif_ff;

    function new(virtual fifo_if vif_ff);
        this.vif_ff = vif_ff;
        $display("environment created");
    endfunction

    task build();
        $display("entered into the build phase");
        gen2driv = new();
        exp2sb = new();
        rcv2sb = new();
        gen = new(gen2driv, exp2sb);
        driv = new(vif_ff, gen2driv);
        rcv = new(vif_ff, rcv2sb);
        sb = new(exp2sb, rcv2sb);
    endtask

    task pre_test();
        driv.reset();
    endtask

    task test();
        fork
            gen.main();
            driv.main();
            rcv.start();
            sb.start();
        join_none
    endtask

    task post_test();
        wait (sb.compared_count == gen.repeat_count);
    endtask

    task run();
        pre_test();
        test();
        post_test();
        $display("Simulation ended at %0t", $time);
        $finish();
    endtask
endclass