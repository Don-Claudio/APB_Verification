class apb_monitor #(parameter int DW = 32, parameter int AW = 5);

   virtual apb_if#(DW, AW)               vif;
   mailbox #(apb_mon_txn#(DW, AW))       mon2scb;
   event                                 reset_occurred;
   apb_mon_txn#(DW, AW)                  txn;
   int unsigned                          wait_cycles;
   logic [2:0] reg_idx;

   covergroup cg_robustness;
      cp_pstrb_pattern : coverpoint txn.pstrb iff (txn.pwrite && !aborted){
         bins full = {4'b1111};
         bins zero = {4'b0000};
         bins  partial = {[4'b0001:4'b1110]};
      }

      cp_psel_abort : coverpoint aborted {
         bins happened = {1};
      }
   endgroup

   covergroup cg_errors;

      cp_reg : coverpoint reg_idx {
         bins reg_00   = {0};
         bins reg_04   = {1};
         bins reg_08   = {2};
         bins reg_0C   = {3};
         bins reg_10   = {4};
         bins unmapped = {[5:7]};
      }

      cp_dir : coverpoint txn.pwrite {
         bins read  = {0};
         bins write = {1};
      }

      cp_err : coverpoint txn.pslverr {
         bins none  = {0};
         bins error = {1};
      }

      cx_err : cross cp_reg, cp_dir, cp_err {
         option.cross_auto_bin_max = 0;   // only the cells we name below

         bins wr_to_RO   = binsof(cp_dir.write) && binsof(cp_reg) intersect {3,4}
                           && binsof(cp_err.error);
         bins rd_from_WO = binsof(cp_dir.read) && binsof(cp_reg.reg_04)
                           && binsof(cp_err.error);
         bins legal_write_clean = binsof(cp_dir.write) && binsof(cp_reg) intersect {0,1,2}
                           && binsof(cp_err.none);
         bins legal_read_clean  = binsof(cp_dir.read) && binsof(cp_reg) intersect {0,2,3,4}
                           && binsof(cp_err.none);
         bins unmapped_clean = binsof(cp_reg.unmapped) && binsof(cp_err.none);
      }

   endgroup


   covergroup cg_hw_interface;
      cp_hw_ctl : coverpoint txn.hw_ctl{
         bins rise = (0=>1);
         bins fall = (1=>0);
      }

      cp_hw_sts : coverpoint txn.hw_sts iff (!txn.pwrite && reg_idx == 4){
         bins low = {0};
         bins high = {1};
      }
   endgroup

   covergroup cg_address;
      cp_reg : coverpoint reg_idx{
         bins reg_00 = {0};
         bins reg_04 = {1};
         bins reg_08 = {2};
         bins reg_0C = {3};
         bins reg_10 = {4};
         bins unmapped = {[5:7]};
      }

      cp_dir : coverpoint txn.pwrite{
         bins read = {0};
         bins write = {1};
      }

      cx_reg_x_dir : cross cp_reg, cp_dir;
   endgroup


   covergroup cg_transaction;
      cp_direction : coverpoint txn.pwrite{
         bins read = {0};
         bins write = {1};
      }

      cp_wait_cycles : coverpoint wait_cycles{
         bins fast = {1};
         bins slow = {2};
      }

      cx_dir_x_wait : cross cp_direction, cp_wait_cycles{
         illegal_bins write_but_slow = binsof(cp_direction.write) && binsof(cp_wait_cycles.slow);
         illegal_bins read_but_fast = binsof(cp_direction.read) && binsof(cp_wait_cycles.fast);
      }

   endgroup

   function new(virtual apb_if#(DW, AW)         vif,
                mailbox #(apb_mon_txn#(DW, AW)) mbx,
                event reset_evt);
      this.vif     = vif;
      this.mon2scb = mbx;
      this.reset_occurred = reset_evt;
      cg_transaction = new();
      cg_address = new();
      cg_hw_interface = new();
      cg_errors = new();
      cg_robustness = new();

   endfunction

   task watch_reset();
      forever begin
         @(negedge vif.presetn);
         -> reset_occurred;
      end
   endtask

   task run();

      fork
         watch_reset();
      join_none


      forever begin
         @(vif.cb);
         #0;

         while (!(vif.psel ===1'b1 && vif.penable === 1'b0)) begin
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

        wait_cycles = 0;
        fork
            begin: wait_pready
               while (!vif.cb.pready) begin
                  @(vif.cb);
                  wait_cycles++;
               end
            end
            begin: wait_abort
               @(negedge vif.psel);
            end
        join_any
        disable fork;

        if (!vif.psel) begin
         aborted = 1;
         cg_robustness.sample();
         aborted = 0;
         // Aborted mid-ACCESS — psel dropped before pready ever asserted.
         // Nothing completed; silently drop this transaction, don't report it.
         continue;
        end

         #0;

         txn.prdata  = vif.cb.prdata;
         txn.pslverr = vif.cb.pslverr;

         cg_transaction.sample();
         cg_address.sample();
         cg_hw_interface.sample();
         cg_errors.sample();
         mon2scb.put(txn);
      end
   endtask

endclass : apb_monitor
