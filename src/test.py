# import cocotb
# from cocotb.clock import Clock
# from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

# @cocotb.test()
# async def test_my_design(dut):
#     CONSTANT_CURRENT = 40

#     dut._log.info("Start Simulation")

#     #init clock 
#     clock = Clock(dut.clk, 1, units="ns")
#     cocotb.start_soon(clock.start())

#     dut.rst_n.value = 0
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = 1 

#     dut.ui_in.value = CONSTANT_CURRENT
#     dut.ena.value = 1 

#     for i in range(100):
#         await RisingEdge(dut.clk)
    
#     assert dut.ui_in.value == dut.ui_in.value
#     dut._log.info("Finished Test")

import cocotb
from cocotb.regression import TestFactory
from cocotb.result import TestFailure

@cocotb.coroutine
def test_lif_neuron(dut):
    # Initialize inputs
    dut.ui_in <= 0
    dut.uio_in <= 0
    dut.rst_n <= 1
    dut.ena <= 1

    # Wait for a few clock cycles
    for _ in range(10):
        yield cocotb.edge(dut.clk)

    # Apply some input current
    dut.ui_in <= 8'h12;

    # Wait for a few clock cycles
    for _ in range(10):
        yield cocotb.edge(dut.clk)

    # Check for spikes
    if dut.uo_out[7]:
        raise TestFailure("Spike detected!")

# Create a test factory
tf = TestFactory(test_lif_neuron)

# Add the testbench module
tf.add_option("-sv")

# Create the test
tf.generate_tests()
