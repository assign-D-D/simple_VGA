onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+sdram -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.sdram xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {sdram.udo}

run -all

endsim

quit -force
