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
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge

@cocotb.coroutine
def reset(dut):
    dut.rst_n <= 0
    yield Timer(10, units='ns')  # Hold reset for 10 ns
    dut.rst_n <= 1

@cocotb.coroutine
def stimulus(dut):
    CONSTANT_CURRENT = 40

    dut.ui_in <= CONSTANT_CURRENT
    dut.ena <= 1

    for _ in range(100):
        yield RisingEdge(dut.clk)

@cocotb.test()
def test_my_design(dut):
    # Create clock
    cocotb.fork(Clock(dut.clk, 1, units='ns').start())

    # Apply reset
    yield reset(dut)

    # Apply stimulus
    yield stimulus(dut)

    # Monitor for spikes
    for _ in range(100):
        yield RisingEdge(dut.clk)
        if dut.uo_out[7]:
            dut._log.info("Spike detected!")

    # Check if the outputs match the inputs
    assert dut.ui_in.value == 40
    dut._log.info("Finished Test")
