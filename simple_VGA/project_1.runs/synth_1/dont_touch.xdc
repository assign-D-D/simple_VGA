# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/constraint_bir.xdc

# IP: ip/rom/rom.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==rom || ORIG_REF_NAME==rom} -quiet] -quiet

# IP: ip/various_clk/various_clk.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==various_clk || ORIG_REF_NAME==various_clk} -quiet] -quiet

# XDC: ip/rom/rom_ooc.xdc

# XDC: ip/various_clk/various_clk_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==various_clk || ORIG_REF_NAME==various_clk} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/various_clk/various_clk.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==various_clk || ORIG_REF_NAME==various_clk} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/various_clk/various_clk_ooc.xdc