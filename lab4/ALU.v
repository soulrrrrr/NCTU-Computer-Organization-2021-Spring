module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, less, overflow );

//I/O ports 
input signed[32-1:0]  aluSrc1;
input signed[32-1:0]  aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 less;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 less;
wire			 overflow;
reg	[32-1:0] result;

//Main function
assign zero = (result==0);
assign less = (result==1);
always @(ALU_operation_i, aluSrc1, aluSrc2) begin
	case (ALU_operation_i)
		0: result <= aluSrc1 & aluSrc2;
		1: result <= aluSrc1 | aluSrc2;
		2: result <= aluSrc1 + aluSrc2;
		6: result <= aluSrc1 - aluSrc2;
		7: result <= aluSrc1 < aluSrc2 ? 1 : 0;
		8: result <= aluSrc1 < 0 ? 1 : 0; //lab 4 implemented
		12: result <= ~(aluSrc1 | aluSrc2);
		default: result <= 0;
	endcase
end


endmodule
