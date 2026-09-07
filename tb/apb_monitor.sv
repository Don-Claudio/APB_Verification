class apb_monitor #(parameter int DW = 32, parameter int AW = 5);

   virtual apb_if#(DW, AW)               vif;
   mailbox #(apb_mon_txn#(DW, AW))       mon2scb;

   function new(virtual apb_if#(DW, AW)         vif,
                mailbox #(apb_mon_txn#(DW, AW)) mbx);
      this.vif     = vif;
      this.mon2scb = mbx;
   endfunction

   task run();
      apb_mon_txn#(DW, AW) txn;
      logic [2:0] reg_idx;

      forever begin
         @(vif.cb);
         #0;

         while (!vif.psel || vif.penable) begin
            @(vif.cb);
            #0;
         end

         txn = new();
         txn.paddr  = vif.paddr;
         txn.pwrite = vif.pwrite;
         txn.pwdata = vif.pwdata;
         txn.pstrb  = vif.pstrb;
         txn.hw_ctl = vif.hw_ctl;   // unconditional snapshot, reflects
                                    // any prior 0x00 write by construction

         reg_idx = txn.paddr[AW-1:2];

         if (!txn.pwrite && reg_idx == 4) begin
            txn.hw_sts = vif.hw_sts;
         end

        while (!vif.cb.pready) begin
            @(vif.cb);
        end

         #0;

         txn.prdata  = vif.cb.prdata;
         txn.pslverr = vif.cb.pslverr;

         mon2scb.put(txn);
      end
   endtask

endclass : apb_monitor
