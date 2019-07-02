SBT ?= sbt

# Generate Verilog code
help:
	$(SBT) 'test:runMain gcd.GCDMain --help'

gen-vcd:
	$(SBT) 'test:runMain gcd.GCDMain --generate-vcd-output on'

verilator-sim:
	$(SBT) 'test:runMain gcd.GCDMain --backend-name verilator'

wave-view: gen-vcd
	gtkwave test_run_dir/gcd.GCDMain2061991994/GCD.vcd

synth: verilator-sim
	cp test_run_dir/gcd.GCDMain2061991994/*.v rtl/
	yosys script/rtl2vsclib.ys

clean:
	-rm -rf project target
	-rm -rf test_run_dir
