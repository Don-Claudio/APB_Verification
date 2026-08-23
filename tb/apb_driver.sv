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
         vif.hw_sts <= $urandom;
      end
   endtask


   task run();
      apb_transaction#(DW, AW) tr;

      fork
         drive_hw_sts();
      join_none

      forever begin
         gen2drv.get(tr);

         vif.cb.paddr <= tr.paddr;
         vif.cb.pwrite <= tr.pwrite;
         vif.cb.pwdata <= tr.pwdata;
         vif.cb.psel <= 1;
         vif.cb.penable <= 0;

         @(vif.cb);

         vif.cb.penable <= 1;

         while (!vif.cb.pready) begin
            @(vif.cb);
         end

        vif.cb.psel <= 0;
        vif.cb.penable <= 0;

        -> drv_done;

     end
   endtask

endclass : apb_driver
