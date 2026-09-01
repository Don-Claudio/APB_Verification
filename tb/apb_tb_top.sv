module apb_tb_top;
   import apb_pkg::*;

   localparam int DW = 32;
   localparam int AW = 5;

   logic pclk;
   logic presetn;

   initial begin
      pclk = 0;
      forever #5 pclk = ~pclk;
   end

   initial begin
      presetn = 0;
      repeat (2) @(posedge pclk);
      presetn = 1;
   end

   apb_if #(.DW(DW), .AW(AW)) vif_inst (
      .pclk    (pclk),
      .presetn (presetn)
   );

   apb_slave #(.DW(DW), .AW(AW)) dut (
      .pclk     (pclk),
      .presetn  (presetn),
      .i_paddr  (vif_inst.paddr),
      .i_pwrite (vif_inst.pwrite),
      .i_psel   (vif_inst.psel),
      .i_penable(vif_inst.penable),
      .i_pwdata (vif_inst.pwdata),
      .i_pstrb  (vif_inst.pstrb),
      .o_prdata (vif_inst.prdata),
      .o_pslverr(vif_inst.pslverr),
      .o_pready (vif_inst.pready),
      .o_hw_ctl (vif_inst.hw_ctl),
      .i_hw_sts (vif_inst.hw_sts)
   );

   apb_test #(.DW(DW), .AW(AW)) test;

   initial begin
      @(posedge presetn);   // explicit wait — don't start the test until
                             // top's own reset sequence has completed
      test = new(vif_inst);
      test.run();
   end

endmodule : apb_tb_top
