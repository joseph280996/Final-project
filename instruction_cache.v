module Instruction_Cache(
PC,
instruction
);
input [63:0]PC;
output reg [31:0] instruction;
reg [31:0] instructionMem [6:0];
initial begin
	instructionMem[0] = 32'b1111_1000_0100_0000_0000_0010_1000_0001;
	instructionMem[1] = 32'b1000_1011_0000_0001_0000_0000_0010_0010;
	instructionMem[2] = 32'b1101_0001_0000_0000_0000_0011_0011_0011;
	instructionMem[3] = 32'b1011_0100_0000_0000_0000_0000_1110_0011;
	instructionMem[4] = 32'b1001_0001_0000_0000_0010_0010_1001_0100;
	instructionMem[5] = 32'b1111_1000_0001_1111_0100_0010_1000_0001;
	instructionMem[6] = 32'b0001_0111_1111_1111_1111_1111_1111_1010;
end
always @(*)begin
	case (PC)
	64'b100: begin
		instruction = instructionMem[0];
	end
	64'b1000: begin
		instruction = instructionMem[1];
	end
	64'b1100: begin
		instruction = instructionMem[2];
	end
	64'b10000: begin
		instruction = instructionMem[3];
	end
	64'b10100: begin
		instruction = instructionMem[4];
	end
	64'b11000: begin
		instruction = instructionMem[5];
	end
	64'b11100: begin
		instruction = instructionMem[6];
	end
	endcase
end
endmodule

