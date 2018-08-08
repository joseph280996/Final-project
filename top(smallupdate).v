module top;


reg [31:0]instruction, alu_input, adder_input; // pc input
reg [1:0] mux_input;
wire[31:0]adder_output, alu_output;
wire[1:0] mux_output;




reg [31:0]ReadAddress; //instruction cache input
wire[31:0]decoder;  // output

//reg [31:0] instruction;
reg  [4:0] r_one;//reg 1 for operand prep
reg  [4:0] r_two;//reg 2 for operand prep
reg [4:0] writeReg;
wire [7:0]enable;//decoder output
wire [3:0] ALUOp;//ALU operational code
wire [63:0] extensionOut;
Decoder decoderr( instruction, enable, extensionOut, ALUOp, r_one, r_two, writeReg);
 
reg [31:0]writedata;
reg regWrite = enable[7];
wire [31:0]readdata_one; //operand_prep output
wire [31:0]readdata_two;
Operand_Prep register_Immediate ( r_one, r_two, writedata, readdata_one, readdata_two, regWrite, writeReg, extensionOut);

reg [31:0] A,B;  // ALU 32-bit Inputs                 
reg [3:0] a_sel;// ALU Selection
wire [31:0] out;
wire zero;//zero out put to go through AND gate with branch
ALU alu (.A(readdata_one), .B(readdata_two), .enable(ALUOp), .out(out));


PC pc(mux_input, alu_input, adder_input, mux_output, adder_output, instruction)	
	always (@)* begin	
 		assign mux_input = mux_output;
		assign alu_input = alu_output;		
		assign adder_input = adder_output;
		assign instruction = 32'b1111_1000_0100_0000_0000_0010_1000_0001;
		assign alu_input = instruction;
		assign adder_input = instruction;
		

	initial begin
		$monitor("Instruction value: %b, alu_output: %b, adder_output: %b, mux_out %b", instruction, alu_output, adder_output, mux_output);
		end
endmodule



Instruction_Cache d4(ReadAddress, decoder);

initial begin
assign ReadAddress = decoder;
ReadAddress =32'b1111_1000_0100_0000_0000_0010_1000_0001;

	$monitor("Decoder value: %b", Decoder);
end 



















reg [31:0]addr;
reg [31:0]inputData;
reg WriteData, ReadData;
wire [31:0]Data;
wire MissFlag;


dataMemory dCache(Data, MissFlag, addr, inputData, WriteData, ReadData);

	initial begin
			WriteData = 0;
		   addr = 32'h00001004; ReadData = 1;
		#5 addr = 32'h00001028; 
		#5 addr = 32'h00001008; WriteData = 1;  ReadData = 0; inputData = 32'hACAC_ACAC;
		#5 addr = 32'h00001028; WriteData = 0; ReadData = 1;
		#5 addr = 32'h20001024;
		#5 addr = 32'h00001014;
		#5 addr = 32'h00001014; WriteData = 1; inputData = 32'hABCD_EF00;  ReadData = 0;
		#5 addr = 0;  ReadData = 1;
	end

	initial begin
		$monitor("Address: %h, Block Address: %h, Data: %h, Miss: %b", addr, addr[31:3], Data, MissFlag);
	end

endmodule




module PC (
mux_input,
adder_input,   // whats in PC + 4 
adder_output,  // to values of din_0
alu_output,
alu_input,  // Pc to alu
instruction,   // 32 bit number 
mux_out,   // mux out back to pc 
din_0,   // mux value 0
din_1,   // mux value 1 
);
input din_0, din_1; 
input [31:0] instruction, alu_input, adder_input;
input [1:0]  mux_input;
output [31:0] mux_out, adder_output, alu_output;
output [1:0] mux_out;

endmodule









module Instruction_Cache(
PC,
instruction
);
input [63:0]PC;
output [31:0] instruction;
reg [31:0] instructionMem [6:0];
initial begin
	
end
always @ (*) begin
	Case (PC)
	64?b01: begin 	
end
endmodule









module Decoder(
instruction,    //32 bits
enable,	// (reg2logc,uncondbranch,branch?)
extensionOut,
ALUOp,
r_one,
readReg2
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




module Operand_Prep(
readreg_one,
readreg_two,
writedata,
readdata_one,
readdata_two,
regWrite,
writeReg,
immediate
);
input [9:5] readreg_one;
input [20:16]readreg_two;
input regWrite;
input [4:0] writeReg ;
input [31:0]writeData;
input [31:0]immediate;
reg [30:0] i;
wire [4:0] registers[31:0];
wire [31:0] registersData[31:0];
output reg [31:0]readData1;
output reg [31:0]readData2;
always @(*)
begin
for ( i=0; i<32; i=i+1) begin 
		if(readreg_one == registers[i]) begin
			readData1 = registersData[i];
		end
		if (readreg_two == registers[i]) begin
readData2 = registersData[i];		
end
if (regWrite) begin
		If (writeReg == registers[i]) begin 
	registersData[i] = writeData;
end
end
endmodule



module ALU(
        input [31:0] A,B,  // ALU 32-bit Inputs                 
        input [3:0] enable,// ALU Selection
        output [31:0] out, // ALU 32-bit Output
	output zero
    );
    reg [31:0] a_result;
    assign a_out = a_result; // ALU out
    assign zero = 0;
always @(*)
    begin
        case(a_sel)

        	4'b0010: // Addition & LDUR & STUR
        a_result = A + B ; 
        
		4'b1010: // Subtraction
        a_result = A - B ; 

		 4'b0110: //  Logical and 
        a_result = A & B;
         
		 4'b0100: //  Logical or
        a_result = A | B;

		 4'b0101: //  Logical nor
        a_result = ~(A | B);
         
		 4'b1100: // Logical nand 
        a_result = ~(A & B);

		4'b0111: //   CBZ ??      
	a_result = (A==0)?(A+B):A;
		
		4'b0001: //CBNZ
	a_result = (A != 0)? (A+B):A;
		
		4'b1101: // MOV ??   
        a_result = (A==B);
          
		  default: a_result = A + B ; 
        endcase
    end
endmodule 





reg [31:0]addr;
	wire [31:0]Data;
	wire MissFlag;
	reg [31:0]inputData;
	reg WriteData, ReadData;

	dataMemory dCache(Data, MissFlag, addr, inputData, WriteData, ReadData);

	initial begin
			WriteData = 0;
		   addr = 32'h00001004; ReadData = 1;
		#5 addr = 32'h00001028; 
		#5 addr = 32'h00001008; WriteData = 1;  ReadData = 0; inputData = 32'hACAC_ACAC;
		#5 addr = 32'h00001028; WriteData = 0; ReadData = 1;
		#5 addr = 32'h20001024;
		#5 addr = 32'h00001014;
		#5 addr = 32'h00001014; WriteData = 1; inputData = 32'hABCD_EF00;  ReadData = 0;
		#5 addr = 0;  ReadData = 1;
	end

	initial begin
		$monitor("Address: %h, Block Address: %h, Data: %h, Miss: %b", addr, addr[31:3], Data, MissFlag);
	end
module dataMemory(output reg [31:0]data, 
						output reg missFlag, 
						input [31:0]addr, 
						input [31:0]inputData,
						input writeData,
						input readData); //inputData and writeData would be used if we had an imperfect cache that would go to a lower level and get more data to load into this iCache.  Here we include but ignore it.

	reg [28:0]set0Address[0:15];
	reg [31:0]set0Data[0:15]; 
	reg [14:0]i;
	wire [28:0]blockAddress = addr[31:3];
	wire setID = blockAddress % 2;

	always@(blockAddress, inputData, setID, writeData, readData) begin : search
		if(setID) begin //set 1
				for(i = 0; i < 16; i=i+1) begin //how many lines there are
					if(blockAddress == set0Address[i]) begin
						if(readData) begin
							data = set0Data[i];
						end //if
						else if(writeData) begin
							set0Data[i] = inputData;
							data = set0Data[i];
						end //else
					
						missFlag = 0;
						disable search;
					end //if PC==
					else begin
						missFlag = 1;
						data = 32'bx;
						
					end
				end //for
		end //if

		else begin
				for(i = 0; i < 16; i=i+1) begin //how many lines there are
					if(blockAddress == set0Address[i]) begin
						if(readData) begin
							data = set0Data[i];
						end //if
						else if (writeData) begin
							set0Data[i] = inputData;
							data = set0Data[i];
						end //else
					
						missFlag = 0;
						disable search;
					end //if PC==
					else begin
						missFlag = 1;
						data = 32'bx;
					end //else
				end //for
			end //else
	end //always


	initial begin
		set0Address[0] = 29'h00000202; set0Data[0] = 32'h01010101;
		set0Address[1] = 29'h00000204; set0Data[1] = 32'h02020202;
		set0Address[2] = 29'h00000206; set0Data[2] = 32'h03030303;
		set0Address[3] = 29'h00000208; set0Data[3] = 32'h04040404;
		set0Address[4] = 29'h0000020A; set0Data[4] = 32'h05050505;
		set0Address[5] = 29'h0000020C; set0Data[5] = 32'h06060606;
		set0Address[6] = 29'h0000020E; set0Data[6] = 32'h07070707;
		set0Address[7] = 29'h00000210; set0Data[7] = 32'h08080808;

		set0Address[0] = 29'h00000201; set0Data[0] = 32'h99999999;
		set0Address[1] = 29'h00000203; set0Data[1] = 32'hAAAAAAAA;
		set0Address[2] = 29'h00000205; set0Data[2] = 32'hBBBBBBBB;
		set0Address[3] = 29'h00000207; set0Data[3] = 32'hCCCCCCCC;
		set0Address[4] = 29'h00000209; set0Data[4] = 32'hDDDDDDDD;
		set0Address[5] = 29'h0000020B; set0Data[5] = 32'hEEEEEEEE;
		set0Address[6] = 29'h0000020D; set0Data[6] = 32'hFFFFFFFF;
		set0Address[7] = 29'h0000020F; set0Data[7] = 32'h01234567;
	end

endmodule

