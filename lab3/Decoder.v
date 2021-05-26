module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
reg	[3-1:0] ALUOp_o;
reg			ALUSrc_o;
reg			RegWrite_o;
reg			RegDst_o;

//Main function
/*your code here*/

always @ (*) begin
    if(instr_op_i == 0)begin
        ALUOp_o <= 3'b010; //2:rformat
		ALUSrc_o <= 1'b0;
		RegWrite_o <= 1'b1;
		RegDst_o <= 1'b1;
    end
    if(instr_op_i == 8)begin
        ALUOp_o <= 3'b000; //0:addi
		ALUSrc_o <= 1'b1;
		RegWrite_o <= 1'b1;
		RegDst_o <= 1'b0;
    end
end

endmodule
   