`include "environment.sv"

program test(fifo_if inf);
    environment env;

    initial begin
        env = new(inf);
        env.build();
        env.gen.repeat_count = 16; // 8 writes + 8 reads to match waveform
        env.pre_test();
        env.test();
        env.run();
    end
endprogram