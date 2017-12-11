all:
	iverilog -o cpu ALU.v Hazard_Detection_Unit.v Pipe_EX_MEM.v ALU_Control.v IF_ID_Flush.v Pipe_ID_EX.v Adder.v Instruction_Memory.v Pipe_IF_ID.v Branch_And.v Mux10.v Pipe_MEM_WB.v CPU.v Mux32.v Registers.v Control.v Mux32_3.v Sign_Extend.v Data_Memory.v Mux5.v Equal.v MuxControl.v Forwarding_Unit.v PC.v ShiftLeft2.v testbench.v

clean:
	rm cpu output.txt
