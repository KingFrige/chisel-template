SBT ?= sbt

# Generate Verilog code
help:
	@echo ""
	@echo "run-help"
	@echo "     look test help"
	@echo ""
	@echo "gen-vcd"
	@echo "     genarate VCD file"
	@echo ""
	@echo "verilator-sim"
	@echo "     use verilator simulation"
	@echo ""
	@echo "wave-view"
	@echo "     use gtkwave debug wave"
	@echo ""
	@echo "synth"
	@echo "     use yosys synthesize verilog"
	@echo ""
	@echo "clean"
	@echo "     delect intermediate data"
	@echo ""

run-help:
	$(SBT) 'test:runMain gcd.GCDMain --help'

gen-vcd:
	$(SBT) 'test:runMain gcd.GCDMain --generate-vcd-output on'

verilator-sim:
	$(SBT) 'test:runMain gcd.GCDMain --backend-name verilator'

vcdFile := $(shell ls -lt test_run_dir/*/* | grep GCD.vcd | head -n 1 | awk '{print $$9}')
wave-view: gen-vcd $(vcdFile)
	gtkwave ${vcdFile}

verilogFile := $(shell ls -lt test_run_dir/*/* | grep GCD.v$$ | head -n 1 | awk '{print $$9}')
synth: $(verilogFile)
	cp ${verilogFile} rtl/
	yosys script/rtl2vsclib.ys

clean:
	-rm -rf project target
	-rm -rf test_run_dir
