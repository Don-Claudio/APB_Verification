`timescale 1ns / 1ps

class apb_driver #(parameter int DW = 32, parameter int AW = 5);

   virtual apb_if#(DW, AW)              vif;
   mailbox #(apb_transaction#(DW, AW))  gen2drv;
   event                                drv_done;

   function new(virtual apb_if#(DW, AW)             vif,
                mailbox #(apb_transaction#(DW, AW))  mbx,
                event                                done);
      this.vif     = vif;
      this.gen2drv = mbx;
      this.drv_done = done;
   endfunction

   task drive_hw_sts();
   forever begin
      @(posedge vif.pclk);
      vif.hw_sts <= $urandom_range(0,1);
   end
   endtask

   task drive_transaction(apb_transaction#(DW, AW) tr);
      vif.cb.paddr   <= tr.paddr;
      vif.cb.pwrite  <= tr.pwrite;
      vif.cb.pwdata  <= tr.pwdata;
      vif.cb.psel    <= 1;
      vif.cb.penable <= 0;

      @(vif.cb);

      vif.cb.penable <= 1;
      @(vif.cb);

      while (!vif.cb.pready) begin
         @(vif.cb);
      end

      vif.cb.psel    <= 0;
      vif.cb.penable <= 0;
   endtask

   task run_write_streak_test(int num_writes, logic [AW-1:0] addr);
      apb_transaction#(DW, AW) tr;
      repeat (num_writes) begin
         tr = new();
         assert(tr.randomize() with { paddr == addr; pwrite == 1; });
         drive_transaction(tr);
      end
   endtask

   task run_read_streak_test(int num_reads, logic [AW-1:0] addr);
      apb_transaction#(DW, AW) tr;
      repeat (num_reads) begin
         tr = new();
         assert(tr.randomize() with { paddr == addr; pwrite == 0; });
         drive_transaction(tr);
      end
   endtask

   task run_psel_abort_test(logic [AW-1:0] addr, logic [DW-1:0] abort_data);
      // SETUP, same as always
      vif.cb.paddr   <= addr;
      vif.cb.pwrite  <= 1;
      vif.cb.pwdata  <= abort_data;
      vif.cb.psel    <= 1;
      vif.cb.penable <= 0;
      @(vif.cb);

      // Enter ACCESS, then abort before pready/completion
      vif.cb.penable <= 1;
      @(vif.cb);
      vif.cb.psel    <= 0;   // abort here — before checking pready at all
      vif.cb.penable <= 0;
      @(vif.cb);
   endtask

   task run_pstrb_no_effect_test(logic [AW-1:0] addr);
      apb_transaction#(DW, AW) tr;

      logic [3:0] patterns[3] = '{4'b1111, 4'b0000, 4'b0001};

      foreach (patterns[i]) begin
         tr = new();
         assert(tr.randomize() with { paddr == addr; pwrite == 1; });
         tr.pstrb = patterns[i];
         drive_transaction(tr);
      end
   endtask


   task run();
      apb_transaction#(DW, AW) tr;

      fork
         drive_hw_sts();
      join_none

      forever begin
         gen2drv.get(tr);
         drive_transaction(tr);

        -> drv_done;

     end
   endtask

endclass : apb_driver
