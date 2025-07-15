class generator;
    mailbox gen2driv;
    mailbox exp2sb;
    int repeat_count;
    int count;

    function new(mailbox gen2driv, mailbox exp2sb);
        this.gen2driv = gen2driv;
        this.exp2sb = exp2sb;
        $display("allocated memory for generator");
    endfunction

    task main();
        bit [7:0] data_seq[$] = '{8'h98, 8'hd5, 8'h06, 8'hfb, 8'h2e, 8'hf5, 8'h5c, 8'hf2}; // Match waveform data
        repeat(repeat_count) begin
            transactor trans = new();
            if (count < data_seq.size()) begin
                trans.wr = 1;
                trans.rd = 0;
                trans.data_in = data_seq[count];
                #45; // Delay to start writes at 50ns (accounting for initial clock cycles)
            end else if (count >= data_seq.size() && count < data_seq.size() * 2) begin
                trans.wr = 0;
                trans.rd = 1;
                trans.data_in = 8'h00;
                #250; // Delay to start reads at 300ns (after writes complete)
            end
            if (!trans.randomize()) $fatal("packet is not randomised");
            else $display(" %d :randomization is successful", ++count);

            transactor trans_exp = trans.clone();
            gen2driv.put(trans);
            exp2sb.put(trans_exp);
        end
    endtask
endclass