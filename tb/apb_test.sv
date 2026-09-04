`timescale 1ns / 1ps

class apb_test #(parameter int DW = 32, parameter int AW = 5);

   apb_env#(DW, AW) env;
   virtual apb_if#(DW,AW) vif;

   function new(virtual apb_if#(DW, AW) vif);
    this.vif = vif;

   endfunction

   task run();
      env = new(vif);
      env.run(200);

      repeat (10) @(vif.cb);

      $finish;

   endtask

endclass : apb_test
