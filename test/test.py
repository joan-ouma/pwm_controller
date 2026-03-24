import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_pwm(dut):
    dut._log.info("Starting PWM test")

    # Start a 50MHz clock (20ns period)
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset the chip
    dut._log.info("Resetting design")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset complete")

    # Test Case 1: 50% Duty Cycle (127 out of 255)
    dut._log.info("Testing 50% duty cycle")
    dut.ui_in.value = 127
    
    # Let it run for two full PWM cycles (256 * 2 = 512 clock ticks)
    await ClockCycles(dut.clk, 512)

    # Test Case 2: 25% Duty Cycle (64 out of 255)
    dut._log.info("Testing 25% duty cycle")
    dut.ui_in.value = 64
    
    # Let it run for another two full cycles
    await ClockCycles(dut.clk, 512)

    dut._log.info("Finished testing!")
