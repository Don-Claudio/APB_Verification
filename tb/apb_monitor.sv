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
      forever begin
        @(vif.cb);
        #0;

        while(!vif.psel || vif.penable) begin
            @(vif.cb);
        end

        txn = new();

        txn.paddr = vif.paddr;
        txn.pwrite = vif.pwrite;
        txn.pwdata = vif.pwdata;
        txn.pstrb = vif.pstrb;

        while(!vif.cb.pready) begin
            @(vif.cb);
        end

        #0;

        txn.prdata = vif.cb.prdata;
        txn.pslverr = vif.cb.pslverr;

        if (!txn.pwrite && txn.paddr == 16) begin
            txn.hw_ctl = vif.hw_ctl;
        end

        mon2scb.put(txn);

      end

    endtask

endclass : apb_monitor
