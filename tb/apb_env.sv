`timescale 1ns / 1ps

class apb_env #(parameter int DW = 32, parameter int AW = 5);

   virtual apb_if#(DW, AW) vif;

   mailbox #(apb_transaction#(DW, AW)) gen2drv;
   mailbox #(apb_mon_txn#(DW, AW))     mon2scb;
   event                               drv_done;

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
      mon = new(vif,mon2scb);
      scb = new(mon2scb);
   endfunction

   task run(int num_transactions);
      fork
       mon.run();
       scb.run();
      join_none

      fork
        gen.run(num_transactions);
        drv.run();
      join_any
   endtask

endclass : apb_env
