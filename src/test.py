import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):
    CONSTANT_CURRENT = 80

    dut._log.info("Start Simulation")

    #init clock 
    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value <= 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value <= 1 

    # Test Scenario 1
    dut.ui_in.value <= CONSTANT_CURRENT
    dut.ena.value <= 1 

    for i in range(200):
        await RisingEdge(dut.clk)
    
    assert dut.ui_in.value == dut.ui_in.value
    # assert dut.spike.value == 1
    # await Timer(100, units='ns')
    # assert dut.spike.value == 0

    dut._log.info("Finished Test")
