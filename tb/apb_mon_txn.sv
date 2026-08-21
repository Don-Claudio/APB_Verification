class apb_mon_txn #(parameter int DW = 32, parameter int AW = 5);

   logic [AW-1:0]   paddr;
   logic            pwrite;
   logic [DW-1:0]   pwdata;
   logic [DW/8-1:0] pstrb;
   logic [DW-1:0]   prdata;
   logic            pslverr;

endclass : apb_mon_txn
