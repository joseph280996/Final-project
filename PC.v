module PC (
adder_input,   // whats in PC + 4 
adder_output,  // to values of din_0
alu_output,
alu_input,  // Pc to alu
instruction,   // 32 bit number 
mux_input,   // mux out back to pc 
mux_output 
);

input [31:0] instruction, alu_input, adder_input;
input [1:0]   mux_input;
output [31:0] adder_output, alu_output;
output [1:0] mux_output;

endmodule
