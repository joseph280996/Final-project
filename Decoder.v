module Decoder(
instruction,    //32 bits
enable,	// (reg2logc,uncondbranch,branch?)
extensionOut,
ALUOp,
r_one,
readReg2,
r_two
);
input [31:0] instruction;
reg [4:0] immediate;
reg [11:0] control;
output reg [4:0] r_one, readReg2; //registers
output reg [4:0] r_two;
output reg [7:0]  enable;
output reg [63:0] extensionOut;
output reg [3:0] ALUOp;
initial begin
	assign control = instruction [31:21];
	assign r_one = instruction [9:5];
	assign extensionOut = instruction;
	if (enable[0]) begin
		readReg2 = r_two;
end	
else begin
	readReg2 = immediate;
end
end
always @(*)begin
	case (control)
	11'b000101xxxxx:  begin //B
		enable = 8'bx1xxxxxx;
		ALUOp = 4'b1111;	
		end
	11'b100101xxxxx: begin//BL
		enable = 8'bx1xxxxxx;
		ALUOp = 4'b1111;
		end
	11'b10110100xxx: begin //CBZ
		enable = 8'b101xxxx;
		ALUOp = 4'b1111;
		end
	11'b10110101xxx: begin  //CBNZ
		enable = 8'b101xxxx;
		ALUOp = 4'b0001;
		end
	11'b11111000010: begin //LDUR
		enable = 8'bx0011011;
		ALUOp = 4'b0010;
		end
	11'b11111000000: begin //STUR
		enable = 8'bx000x11x;
		ALUOp = 4'b0010;
		end
	11'b10001011000: begin //ADD
		enable = 8'b100x0x01;
		ALUOp = 4'b0010;
		end
	11'b1001000100x: begin //ADDI
		enable = 8'b100x0x11;
		ALUOp = 4'b0010;
		end
	11'b11001011000: begin //SUB
		enable = 8'b100x0x01;
		ALUOp = 4'b1010;
		end
	11'b1101000100x: begin //SUBI
		enable = 8'b100x0x11;
		ALUOp = 4'b1010;
		end
	11'b10001010000: begin //AND
		enable = 8'b100x0x01;
		ALUOp = 4'b0110;
		end
	11'b1001001000x: begin //ANDI
		enable = 8'b100x0x11;
		ALUOp = 4'b0110;
		end
	11'b10101010000: begin //ORR
		enable = 8'b100x0x01;
		ALUOp = 4'b0100;
		end
	11'b1011001000x: begin //ORRI
		enable = 8'b100x0x11;
		ALUOp = 4'b0100;
		end
	11'b11101010000: begin //EOR
		enable = 8'b100x0x01;
		ALUOp = 4'b1001;
		end
	11'b1101001000x: begin //EORI
		enable = 8'b100x0x11;
		ALUOp = 4'b1001;
		end
	endcase
end
endmodule

