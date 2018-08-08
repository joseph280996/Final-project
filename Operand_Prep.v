module Operand_Prep(
readreg_one,
readreg_two,
writeData,
readData1,
readData2,
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
reg [4:0] registers[31:0];
reg [31:0] registersData[31:0];
output reg [31:0]readData1;
output reg [31:0]readData2;
initial 
begin
for ( i =0; i<32; i = i+1 ) begin
	registersData[i] = 0;
	end
end
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
		if (writeReg == registers[i]) begin 
			registersData[i] = writeData;
		end
	end
end
end
endmodule