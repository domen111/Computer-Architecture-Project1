all:
	iverilog -o cpu ALU.v Control.v PC.v ALU_Control.v Instruction_Memory.v Registers.v Adder.v Mux32.v Sign_Extend.v Mux5.v Pipe_IF_ID.v Pipe_ID_EX.v Pipe_EX_MEM.v CPU.v testbench_hw4.v

clean:
	rm cpu output.txt
