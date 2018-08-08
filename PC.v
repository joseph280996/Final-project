module top;
reg [31:0]instruction, alu_input, adder_input; // pc input
reg [1:0] mux_input;
wire[31:0]adder_output, alu_output;
wire[1:0] mux_output;

PC pc(mux_input, alu_input, adder_input, mux_output, adder_output, instruction)	
	
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


module PC (
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
