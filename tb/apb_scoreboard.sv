class apb_scoreboard #(parameter int DW = 32, parameter int AW = 5);

   mailbox #(apb_mon_txn#(DW, AW)) mon2scb;

   // Reference model — persistent per-register storage.
   // 0->0x00, 1->0x04, 2->0x08, 3->0x0C, 4->0x10 (4 unused, see below)
   logic [DW-1:0] expected_reg[5];

   int unsigned mismatches;

   function new(mailbox #(apb_mon_txn#(DW, AW)) mbx);
      this.mon2scb = mbx;
      mismatches   = 0;

      // Reset-value initialization, per spec.md §3.7:
      expected_reg[0] = '0;              // 0x00, RW, resets to 0
      expected_reg[1] = '0;              // 0x04, WO, resets to 0 (unused in practice)
      expected_reg[2] = '0;              // 0x08, RW, resets to 0
      expected_reg[3] = 32'hDEAD_BEEF;   // 0x0C, RO constant, never changes
      expected_reg[4] = '0;              // 0x10, RO+ — unused; hw_sts checked directly,
      //not via this array
   endfunction

   task run();
      apb_mon_txn#(DW, AW) txn;
      forever begin
         mon2scb.get(txn);

         case (txn.paddr)

            // 0x00 (RW) — also drives hw_ctl (FN-7)
            0 : begin
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

            // 0x04 (WO)
            4 : begin
               if (txn.pwrite) begin
                  // Nothing to store — RTL's default case does nothing.
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

            // 0x08 (RW)
            8 : begin
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

            // 0x0C (RO constant)
            12 : begin
               if (txn.pwrite) begin
                  // expected_reg[3] deliberately NOT touched — RTL has no
                  // case entry for index 3, storage is unaffected.
                  if (txn.pslverr !== 1'b1) begin
                     mismatches++;
                     $error("FN-10: pslverr not set on write to RO 0x0C");
                  end
               end else begin
                  if (txn.prdata !== expected_reg[3]) begin
                     mismatches++;
                     $error("FN-5: prdata=%0h, expected constant %0h",
                     txn.prdata, expected_reg[3]);
                  end
                  if (txn.pslverr !== 1'b0) begin
                     mismatches++;
                     $error("FN-12: unexpected pslverr on legal read of 0x0C");
                  end
               end
            end

            // 0x10 (RO+, live hardware) — bypasses expected_reg entirely
            16 : begin
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

            // Unmapped address (FN-8, FN-9)
            default : begin
               if (txn.pwrite) begin
                  // FN-9: write has no effect — nothing to check against
                  // storage since there's no register here; just confirm
                  // no spurious error either.
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
