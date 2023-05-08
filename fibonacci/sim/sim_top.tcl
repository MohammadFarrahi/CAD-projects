	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"fibonacci_tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"100 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/CombAddSub_.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Comparator.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/fib_controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/fibonacci.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Mux_2to1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Mux_3to1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Mux_4to1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Register_.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Rshifter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Stack.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    
#====================================== run =====================================

	run $run_time 
	