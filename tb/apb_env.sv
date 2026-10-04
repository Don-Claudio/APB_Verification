`timescale 1ns / 1ps

class apb_env #(parameter int DW = 32, parameter int AW = 5);

   virtual apb_if#(DW, AW) vif;

   mailbox #(apb_transaction#(DW, AW)) gen2drv;
   mailbox #(apb_mon_txn#(DW, AW))     mon2scb;
   event                               drv_done;
   event                               reset_occurred;

   apb_generator#(DW, AW)  gen;
   apb_driver#(DW, AW)     drv;
   apb_monitor#(DW, AW)    mon;
   apb_scoreboard#(DW, AW) scb;

   function new(virtual apb_if#(DW, AW) vif);
      this.vif = vif;

      gen2drv = new();
      mon2scb = new();

      gen = new(gen2drv,drv_done);
      drv = new(vif,gen2drv,drv_done);
      mon = new(vif,mon2scb, reset_occurred);
      scb = new(mon2scb, reset_occurred);
   endfunction

   task run(int num_transactions);
      fork
       mon.run();
       scb.run();
      join_none

      drv.run_write_streak_test(8, 5'h00);
      drv.run_read_streak_test(9, 5'h00);

      -> vif.reset_midcycle_req;
    #100;

      fork
         -> vif.reset_midtransaction_req;
         drv.run_write_streak_test(1, 5'h00);
      join

      drv.run_write_streak_test(1, 5'h00);        // establish a known value first
      drv.run_psel_abort_test(5'h00, 32'hDEAD_0000); // attempted overwrite, aborted
      drv.run_read_streak_test(1, 5'h00);          // confirm old value survived
      drv.run_pstrb_no_effect_test(5'h08);


      fork
        gen.run(num_transactions);
        drv.run();
      join_any
   endtask

endclass : apb_env
