`timescale 1ns / 1ps

class apb_generator #(parameter int DW = 32, parameter int AW = 5);

   mailbox #(apb_transaction#(DW, AW)) gen2drv;
   event                               drv_done;

   function new(mailbox #(apb_transaction#(DW,AW)) mbx,
            event done);

    this.gen2drv = mbx;
    this.drv_done = done;

    endfunction

   task run(int num_transactions);
      apb_transaction#(DW, AW) tr;
      repeat (num_transactions) begin
        tr = new();

        assert(tr.randomize()) else $fatal("%s:%0d Randomization failed", `__FILE__, `__LINE__);

        gen2drv.put(tr);

        @drv_done;

      end
   endtask

endclass : apb_generator
