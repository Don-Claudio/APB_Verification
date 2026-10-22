Covergroup Coverage:
#     Covergroups                      5        na        na   100.00%
#         Coverpoints/Crosses         14        na        na        na
#             Covergroup Bins         49        49         0   100.00%
# ----------------------------------------------------------------------------------------------------------
# Covergroup                                             Metric       Goal       Bins    Status
#
# ----------------------------------------------------------------------------------------------------------
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_robustness
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_pstrb_pattern                       100.00%        100          -    Covered
#         covered/total bins:                                 3          3          -
#         missing/total bins:                                 0          3          -
#         % Hit:                                        100.00%        100          -
#         bin full                                          220          1          -    Covered
#         bin zero                                            1          1          -    Covered
#         bin partial                                         1          1          -    Covered
#     Coverpoint cp_psel_abort                          100.00%        100          -    Covered
#         covered/total bins:                                 1          1          -
#         missing/total bins:                                 0          1          -
#         % Hit:                                        100.00%        100          -
#         bin happened                                        1          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_errors
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                    15         15          -
#     missing/total bins:                                     0         15          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_reg                                 100.00%        100          -    Covered
#         covered/total bins:                                 6          6          -
#         missing/total bins:                                 0          6          -
#         % Hit:                                        100.00%        100          -
#         bin reg_00                                         62          1          -    Covered
#         bin reg_04                                         46          1          -    Covered
#         bin reg_08                                         43          1          -    Covered
#         bin reg_0C                                         27          1          -    Covered
#         bin reg_10                                         31          1          -    Covered
#         bin unmapped                                       12          1          -    Covered
#     Coverpoint cp_dir                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Coverpoint cp_err                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin none                                          170          1          -    Covered
#         bin error                                          51          1          -    Covered
#     Cross cx_err                                      100.00%        100          -    Covered
#         covered/total bins:                                 5          5          -
#         missing/total bins:                                 0          5          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin wr_to_RO                                   27          1          -    Covered
#             bin rd_from_WO                                 24          1          -    Covered
#             bin legal_write_clean                          78          1          -    Covered
#             bin legal_read_clean                           80          1          -    Covered
#             bin unmapped_clean                             12          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_hw_interface
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_hw_ctl                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#     Coverpoint cp_hw_sts                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#  Covergroup instance \/apb_pkg::apb_monitor::apb_monitor__1::cg_hw_interface
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_hw_ctl                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin rise                                            9          1          -    Covered
#         bin fall                                            9          1          -    Covered
#     Coverpoint cp_hw_sts                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin low                                            16          1          -    Covered
#         bin high                                            7          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_address
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                    20         20          -
#     missing/total bins:                                     0         20          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_reg                                 100.00%        100          -    Covered
#         covered/total bins:                                 6          6          -
#         missing/total bins:                                 0          6          -
#         % Hit:                                        100.00%        100          -
#         bin reg_00                                         62          1          -    Covered
#         bin reg_04                                         46          1          -    Covered
#         bin reg_08                                         43          1          -    Covered
#         bin reg_0C                                         27          1          -    Covered
#         bin reg_10                                         31          1          -    Covered
#         bin unmapped                                       12          1          -    Covered
#     Coverpoint cp_dir                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Cross cx_reg_x_dir                                100.00%        100          -    Covered
#         covered/total bins:                                12         12          -
#         missing/total bins:                                 0         12          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin <unmapped,write>                            4          1          -    Covered
#             bin <reg_10,write>                              8          1          -    Covered
#             bin <reg_0C,write>                             19          1          -    Covered
#             bin <reg_08,write>                             27          1          -    Covered
#             bin <reg_04,write>                             22          1          -    Covered
#             bin <reg_00,write>                             29          1          -    Covered
#             bin <unmapped,read>                             8          1          -    Covered
#             bin <reg_10,read>                              23          1          -    Covered
#             bin <reg_0C,read>                               8          1          -    Covered
#             bin <reg_08,read>                              16          1          -    Covered
#             bin <reg_04,read>                              24          1          -    Covered
#             bin <reg_00,read>                              33          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_transaction
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     6          6          -
#     missing/total bins:                                     0          6          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_direction                           100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Coverpoint cp_wait_cycles                         100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin fast                                          109          1          -    Covered
#         bin slow                                          112          1          -    Covered
#     Cross cx_dir_x_wait                               100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin <read,slow>                               112          1          -    Covered
#             bin <write,fast>                              109          1          -    Covered
#         Illegal and Ignore Bins:
#             illegal_bin read_but_fast                       0                     -    ZERO
#             illegal_bin write_but_slow                      0                     -    ZERO
#
# COVERGROUP COVERAGE:
# ----------------------------------------------------------------------------------------------------------
# Covergroup                                             Metric       Goal       Bins    Status
#
# ----------------------------------------------------------------------------------------------------------
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_robustness
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_pstrb_pattern                       100.00%        100          -    Covered
#         covered/total bins:                                 3          3          -
#         missing/total bins:                                 0          3          -
#         % Hit:                                        100.00%        100          -
#         bin full                                          220          1          -    Covered
#         bin zero                                            1          1          -    Covered
#         bin partial                                         1          1          -    Covered
#     Coverpoint cp_psel_abort                          100.00%        100          -    Covered
#         covered/total bins:                                 1          1          -
#         missing/total bins:                                 0          1          -
#         % Hit:                                        100.00%        100          -
#         bin happened                                        1          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_errors
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                    15         15          -
#     missing/total bins:                                     0         15          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_reg                                 100.00%        100          -    Covered
#         covered/total bins:                                 6          6          -
#         missing/total bins:                                 0          6          -
#         % Hit:                                        100.00%        100          -
#         bin reg_00                                         62          1          -    Covered
#         bin reg_04                                         46          1          -    Covered
#         bin reg_08                                         43          1          -    Covered
#         bin reg_0C                                         27          1          -    Covered
#         bin reg_10                                         31          1          -    Covered
#         bin unmapped                                       12          1          -    Covered
#     Coverpoint cp_dir                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Coverpoint cp_err                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin none                                          170          1          -    Covered
#         bin error                                          51          1          -    Covered
#     Cross cx_err                                      100.00%        100          -    Covered
#         covered/total bins:                                 5          5          -
#         missing/total bins:                                 0          5          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin wr_to_RO                                   27          1          -    Covered
#             bin rd_from_WO                                 24          1          -    Covered
#             bin legal_write_clean                          78          1          -    Covered
#             bin legal_read_clean                           80          1          -    Covered
#             bin unmapped_clean                             12          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_hw_interface
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_hw_ctl                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#     Coverpoint cp_hw_sts                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#  Covergroup instance \/apb_pkg::apb_monitor::apb_monitor__1::cg_hw_interface
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     4          4          -
#     missing/total bins:                                     0          4          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_hw_ctl                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin rise                                            9          1          -    Covered
#         bin fall                                            9          1          -    Covered
#     Coverpoint cp_hw_sts                              100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin low                                            16          1          -    Covered
#         bin high                                            7          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_address
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                    20         20          -
#     missing/total bins:                                     0         20          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_reg                                 100.00%        100          -    Covered
#         covered/total bins:                                 6          6          -
#         missing/total bins:                                 0          6          -
#         % Hit:                                        100.00%        100          -
#         bin reg_00                                         62          1          -    Covered
#         bin reg_04                                         46          1          -    Covered
#         bin reg_08                                         43          1          -    Covered
#         bin reg_0C                                         27          1          -    Covered
#         bin reg_10                                         31          1          -    Covered
#         bin unmapped                                       12          1          -    Covered
#     Coverpoint cp_dir                                 100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Cross cx_reg_x_dir                                100.00%        100          -    Covered
#         covered/total bins:                                12         12          -
#         missing/total bins:                                 0         12          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin <unmapped,write>                            4          1          -    Covered
#             bin <reg_10,write>                              8          1          -    Covered
#             bin <reg_0C,write>                             19          1          -    Covered
#             bin <reg_08,write>                             27          1          -    Covered
#             bin <reg_04,write>                             22          1          -    Covered
#             bin <reg_00,write>                             29          1          -    Covered
#             bin <unmapped,read>                             8          1          -    Covered
#             bin <reg_10,read>                              23          1          -    Covered
#             bin <reg_0C,read>                               8          1          -    Covered
#             bin <reg_08,read>                              16          1          -    Covered
#             bin <reg_04,read>                              24          1          -    Covered
#             bin <reg_00,read>                              33          1          -    Covered
#  TYPE /apb_pkg/apb_monitor/apb_monitor__1/cg_transaction
#                                                       100.00%        100          -    Covered
#     covered/total bins:                                     6          6          -
#     missing/total bins:                                     0          6          -
#     % Hit:                                            100.00%        100          -
#     Coverpoint cp_direction                           100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin read                                          112          1          -    Covered
#         bin write                                         109          1          -    Covered
#     Coverpoint cp_wait_cycles                         100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         bin fast                                          109          1          -    Covered
#         bin slow                                          112          1          -    Covered
#     Cross cx_dir_x_wait                               100.00%        100          -    Covered
#         covered/total bins:                                 2          2          -
#         missing/total bins:                                 0          2          -
#         % Hit:                                        100.00%        100          -
#         Auto, Default and User Defined Bins:
#             bin <read,slow>                               112          1          -    Covered
#             bin <write,fast>                              109          1          -    Covered
#         Illegal and Ignore Bins:
#             illegal_bin read_but_fast                       0                     -    ZERO
#             illegal_bin write_but_slow                      0                     -    ZERO
#
# TOTAL COVERGROUP COVERAGE: 100.00%  COVERGROUP TYPES: 5
#
# Total Coverage By Instance (filtered view): 100.00%
