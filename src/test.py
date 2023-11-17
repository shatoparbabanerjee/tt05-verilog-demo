# import cocotb
# from cocotb.clock import Clock
# from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

# @cocotb.test()
# async def test_my_design(dut):
#     CONSTANT_CURRENT = 80

#     dut._log.info("Start Simulation")

#     #init clock 
#     clock = Clock(dut.clk, 1, units="ns")
#     cocotb.start_soon(clock.start())

#     dut.rst_n.value = 0
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = 1 

#     dut.ui_in.value = CONSTANT_CURRENT
#     dut.ena.value = 1 

#     for i in range(200):
#         await RisingEdge(dut.clk)
    
#     assert dut.ui_in.value == dut.ui_in.value
#     dut._log.info("Finished Test")

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):
    CONSTANT_CURRENT = 80
    NEW_CONSTANT_CURRENT = 100
    SUB_THRESHOLD_CURRENT = 50

    dut._log.info("Start Simulation")

    # Test Scenario 1: Normal Firing
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 

    dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 

    for i in range(200):
        await RisingEdge(dut.clk)
    
    assert dut.ui_in.value == dut.ui_in.value
    assert dut.spike.value == 1  # Verify that the neuron fires
    await Timer(10, units='ns')  # Wait for refractory period
    assert dut.spike.value == 0  # Confirm proper operation of the refractory period

    # Test Scenario 2: Reset and Re-Input
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 

    dut.ui_in.value = NEW_CONSTANT_CURRENT  # Input a different constant synaptic current
    dut.ena.value = 1 

    for i in range(200):
        await RisingEdge(dut.clk)
    
    assert dut.ui_in.value == NEW_CONSTANT_CURRENT
    assert dut.spike.value == 1  # Verify firing behavior after reset and re-input

    # Test Scenario 3: No Firing
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 

    dut.ui_in.value = SUB_THRESHOLD_CURRENT  # Input a sub-threshold synaptic current
    dut.ena.value = 1 

    for i in range(200):
        await RisingEdge(dut.clk)
    
    assert dut.ui_in.value == SUB_THRESHOLD_CURRENT
    assert dut.spike.value == 0  # Confirm that the neuron does not fire

    dut._log.info("Finished Test Scenarios")

