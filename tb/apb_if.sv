`timescale 1ns / 1ps

interface apb_if #(
   parameter int DW = 32,
   parameter int AW = 5
) (
   input logic pclk,
   input logic presetn
);

   logic [AW-1:0] paddr;
   logic          pwrite;
   logic          psel;
   logic          penable;
   logic [DW-1:0] pwdata;
   logic [DW/8-1:0] pstrb;
   logic [DW-1:0] prdata;
   logic          pready;
   logic          pslverr;

   logic            hw_ctl;   // mirrors DUT's o_hw_ctl
   logic            hw_sts;   // mirrors DUT's i_hw_sts


   clocking cb @(posedge pclk);
    output paddr;
    output pwrite, psel, penable;
    output pwdata;
    output pstrb;
    input prdata;
    input pready;
    input pslverr;
   endclocking : cb

   modport TB (clocking cb);

endinterface : apb_if

