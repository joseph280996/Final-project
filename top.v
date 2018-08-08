
module top;


reg [31:0]instruction, alu_input, adder_input; // pc input
reg [1:0] mux_input;
wire[31:0]adder_output, alu_output;
wire[1:0] mux_output;
PC m(adder_input, adder_output, alu_output, alu_input, instruction, mux_output, mux_input);




reg [31:0]ReadAddress; //instruction cache input
reg [31:0] instruction;
reg  [4:0] r_one;//reg 1 for operand prep
reg  [4:0] r_two;//reg 2 for operand prep
reg [4:0] writeReg;
wire [7:0]enable;//decoder output
wire [3:0] ALUOp;//ALU operational code
wire [63:0] extensionOut;
Decoder decoder( instruction,
 enable,
 extensionOut,
 ALUOp,
 r_one,
 writeReg,
 r_two);
 
reg [31:0]writedata;
wire regWrite = enable[7];
wire ALUSrc = enable[6];
wire [31:0]readdata_one; //operand_prep output
wire [31:0]readdata_two;
Operand_Prep registerOp ( r_one,
 r_two,
 writeReg,
 extensionOut,
 writedata,
 readdata_one,
 regWrite,
 ALUSrc,
 readdata_two);

reg [31:0] A,B;  // ALU 32-bit Inputs                 
reg [3:0] a_sel;// ALU Selection
wire [31:0] out;
wire zero;//zero out put to go through AND gate with branch
ALU alu (.A(readdata_one),
 .B(readdata_two),
 .enable(ALUOp),
 .out(out),
 .zero(zero));


reg [31:0]addr;
reg [31:0]inputData;
reg WriteData, ReadData;
wire [31:0]Data;
wire MissFlag;
dataMemory dCache(Data, MissFlag, addr, inputData, WriteData, ReadData);

