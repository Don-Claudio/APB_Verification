`timescale 1ns / 1ps

class apb_transaction #(parameter int DW = 32, parameter int AW = 5);

   rand logic [AW-1:0]   paddr;
   rand logic            pwrite;
   rand logic [DW-1:0]   pwdata;
        logic [DW/8-1:0] pstrb;

   constraint paddr_c {
    paddr dist {0:=20,[1:3]:/20, 4:=20,[5:7]:/20, 8:=20,[9:11]:/20,
    12:=20,[13:15]:/20, 16:=20, [17:31]:/20};
   }


   function new();
      pstrb = '1;
   endfunction

endclass : apb_transaction
