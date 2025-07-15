class scoreboard;
    mailbox exp2sb;
    mailbox rcv2sb;
    int compared_count = 0;

    function new(mailbox exp2sb, mailbox rcv2sb);
        this.exp2sb = exp2sb;
        this.rcv2sb = rcv2sb;
    endfunction

    task start();
        forever begin
            transactor trans_exp, trans_rcv;
            exp2sb.get(trans_exp);
            rcv2sb.get(trans_rcv);
            if (trans_rcv.compare(trans_exp)) begin
                $display("Time %0t: Scoreboard: Packet Matched", $time);
            end else begin
                $display("Time %0t: Scoreboard: Packet Mismatched", $time);
            end
            compared_count++;
        end
    endtask
endclass