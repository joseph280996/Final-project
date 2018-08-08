module Instruction_Cache(
PC,
instruction
);
input [63:0]PC;
output [31:0] instruction;
reg [31:0] instructionMem [6:0];
initial begin
	
assign [31:0]PC = [31:0]instruction;
end
endmodule


Instruction_Cache (PC, instruction, insutrctionMem);

initial begin
assign ReadAddress = decoder;
ReadAddress =32'b1111_1000_0100_0000_0000_0010_1000_0001;

	$monitor("Decoder value: %b", Decoder)
end 
endmodule
