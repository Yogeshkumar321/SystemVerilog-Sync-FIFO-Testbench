class transactor;
    rand bit rd;
    rand bit wr;
    rand bit [7:0] data_in;
    bit [7:0] data_out;
    bit full;
    bit empty;

    constraint rd_wr { rd != wr; }
    constraint data_seq { data_in inside {[8'h98 : 8'hf2]}; }

    function bit compare(transactor actual);
        compare = 1'b1;
        if (actual == null) compare = 0;
        else begin
            if (actual.wr != this.wr) compare = 0;
            if (actual.rd != this.rd) compare = 0;
            if (actual.data_in != this.data_in) compare = 0;
            if (actual.data_out != this.data_out) compare = 0;
            if (actual.full != this.full) compare = 0;
            if (actual.empty != this.empty) compare = 0;
        end
    endfunction

    function transactor clone();
        transactor c = new();
        c.rd = this.rd;
        c.wr = this.wr;
        c.data_in = this.data_in;
        c.data_out = this.data_out;
        c.full = this.full;
        c.empty = this.empty;
        return c;
    endfunction
endclass