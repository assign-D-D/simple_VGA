-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../project_1.srcs/sources_1/ip/clk_400/clk_400_clk_wiz.v" \
  "../../../../project_1.srcs/sources_1/ip/clk_400/clk_400.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

