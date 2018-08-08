module ALU(
        input [31:0] A,B,  // ALU 32-bit Inputs                 
        input [3:0] enable,// ALU Selection
        output [31:0] out, // ALU 32-bit Output
	output zero
    );
    reg [31:0] a_result;
    assign out = a_result; // ALU out
    assign zero = 0;
always @(*)
    begin
        case(enable)

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

