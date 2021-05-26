module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input signed	[32-1:0] aluSrc1;
input signed	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
reg	[32-1:0] result;

//Main function
/*your code here*/
assign zero = (result == 0);
assign overflow = (aluSrc1[31]==aluSrc2[31] & aluSrc1[31]!=result[31]);

always @ (aluSrc1, aluSrc2, ALU_operation_i) begin
    $display(ALU_operation_i);
    $display(aluSrc1);
    $display(aluSrc2);
    case(ALU_operation_i)
		4'b0000: result <= aluSrc1 + aluSrc2;
		4'b0001: result <= aluSrc1 - aluSrc2;
		4'b0010: result <= aluSrc1 & aluSrc2;
		4'b0011: result <= aluSrc1 | aluSrc2;
		4'b0100: result <= ~(aluSrc1 | aluSrc2);
		4'b0101: result <= (aluSrc1 < aluSrc2) ? 1 : 0;
	endcase
    
end

endmodule
