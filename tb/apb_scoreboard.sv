class apb_scoreboard #(parameter int DW = 32, parameter int AW = 5);

   mailbox #(apb_mon_txn#(DW, AW)) mon2scb;

   logic [DW-1:0] expected_reg[5];
   int unsigned mismatches;

   function new(mailbox #(apb_mon_txn#(DW, AW)) mbx);
      this.mon2scb = mbx;
      mismatches   = 0;

      expected_reg[0] = '0;
      expected_reg[1] = '0;
      expected_reg[2] = '0;
      expected_reg[3] = 32'hDEAD_BEEF;
      expected_reg[4] = '0;
   endfunction

   task run();
      apb_mon_txn#(DW, AW) txn;
      forever begin
         mon2scb.get(txn);

         case (txn.paddr)

            0 : begin // 0x00, RW, drives hw_ctl
               if (txn.pwrite) begin
                  expected_reg[0] = txn.pwdata;
                  if (txn.hw_ctl !== expected_reg[0]) begin
                     mismatches++;
                     $error("FN-7: hw_ctl=%0h, expected=%0h", txn.hw_ctl, expected_reg[0]);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal write to 0x00");
                  end
               end else begin
                  if (txn.prdata !== expected_reg[0]) begin
                     mismatches++;
                     $error("FN-1: prdata=%0h, expected=%0h", txn.prdata, expected_reg[0]);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal read of 0x00");
                  end
               end
            end

            4 : begin // 0x04, WO — write DOES update storage (index 1
                      // present in W_ACCESS), read NEVER sees it (index 1
                      // absent from R_ACCESS, falls to default 0)
               if (txn.pwrite) begin
                  expected_reg[1] = txn.pwdata;
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal write to 0x04");
                  end
               end else begin
                  if (txn.prdata !== '0) begin
                     mismatches++;
                     $error("FN-4: read of WO reg 0x04 returned %0h, expected 0", txn.prdata);
                  end
                  if (txn.pslverr !== 1'b1) begin
                     mismatches++;
                     $error("FN-11: pslverr not set on read from WO 0x04");
                  end
               end
            end

            8 : begin // 0x08, RW
               if (txn.pwrite) begin
                  expected_reg[2] = txn.pwdata;
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal write to 0x08");
                  end
               end else begin
                  if (txn.prdata !== expected_reg[2]) begin
                     mismatches++;
                     $error("FN-2: prdata=%0h, expected=%0h", txn.prdata, expected_reg[2]);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal read of 0x08");
                  end
               end
            end

            12 : begin // 0x0C, RO constant — index 3 absent from
                       // W_ACCESS (no-op), present in wr_err list
               if (txn.pwrite) begin
                  if (txn.pslverr !== 1'b1) begin
                     mismatches++;
                     $error("FN-10: pslverr not set on write to RO 0x0C");
                  end
               end else begin
                  if (txn.prdata !== expected_reg[3]) begin
                     mismatches++;
                     $error("FN-5: prdata=%0h, expected constant %0h", txn.prdata, expected_reg[3]);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal read of 0x0C");
                  end
               end
            end

            16 : begin // 0x10, RO+ — index 4 absent from W_ACCESS
                       // (no-op), present in wr_err list; read bypasses
                       // expected_reg entirely, compares to live hw_sts
               if (txn.pwrite) begin
                  if (txn.pslverr !== 1'b1) begin
                     mismatches++;
                     $error("FN-10: pslverr not set on write to RO+ 0x10");
                  end
               end else begin
                  if (txn.prdata !== txn.hw_sts) begin
                     mismatches++;
                     $error("FN-6: prdata=%0h, expected live hw_sts=%0h", txn.prdata, txn.hw_sts);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal read of 0x10");
                  end
               end
            end

            default : begin // unmapped, FN-8/FN-9
               if (txn.pwrite) begin
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-9: unexpected pslverr on write to unmapped addr %0d", txn.paddr);
                  end
               end else begin
                  if (txn.prdata !== '0) begin
                     mismatches++;
                     $error("FN-8: unmapped addr %0d read %0h, expected 0", txn.paddr, txn.prdata);
                  end
               end
            end

         endcase
      end
   endtask

endclass : apb_scoreboard
