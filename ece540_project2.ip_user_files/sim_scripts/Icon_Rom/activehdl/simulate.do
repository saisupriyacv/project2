onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Icon_Rom -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_3 -O5 xil_defaultlib.Icon_Rom xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Icon_Rom.udo}

run -all

endsim

quit -force
