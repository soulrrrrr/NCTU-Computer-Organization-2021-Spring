module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
assign ALU_operation_o = ({ALUOp_i,funct_i} == 9'b010010011 || ALUOp_i == 3'b100) ? 4'b0010 : //add addi
			 		      ({ALUOp_i,funct_i} == 9'b010010001) ? 4'b0110 :  //sub
			 		      ({ALUOp_i,funct_i} == 9'b010010100) ? 4'b0000 :  //and
			 		      ({ALUOp_i,funct_i} == 9'b010010110) ? 4'b0001 :  //or 
			  		      ({ALUOp_i,funct_i} == 9'b010010101) ? 4'b1100 :  //nor 
			 		      ({ALUOp_i,funct_i} == 9'b010110000) ? 4'b0111 :  //slt
			 		      ({ALUOp_i,funct_i} == 9'b010000000) ? 4'b0000 :  //sll
			 		      ({ALUOp_i,funct_i} == 9'b010000010) ? 4'b0001 :  //srl
			 		      ({ALUOp_i,funct_i} == 9'b010000110) ? 4'b0010 :  //sllv
					      ({ALUOp_i,funct_i} == 9'b010000100) ? 4'b0011 : //srlv 
						  (ALUOp_i == 3'b000) ? 4'b0010 : //lw, sw(add)
						  (ALUOp_i == 3'b001 || ALUOp_i == 3'b110) ? 4'b0110 : //beq, bne(sub)
						  (ALUOp_i == 3'b101)? 4'b0111 : //blt
						  (ALUOp_i == 3'b011)? 4'b1000 : //bgez
						  4'b0000;  //others
assign FURslt_o =  ({ALUOp_i,funct_i} == 9'b010010011 || ALUOp_i == 3'b100) ? 2'b00 : //add addi
					({ALUOp_i,funct_i} == 9'b010010001) ? 2'b00 :  //sub
					({ALUOp_i,funct_i} == 9'b010010100) ? 2'b00 :  //and
					({ALUOp_i,funct_i} == 9'b010010110) ? 2'b00 :  //or 
					({ALUOp_i,funct_i} == 9'b010010101) ? 2'b00 :  //nor 
			 		({ALUOp_i,funct_i} == 9'b010110000) ? 2'b00 :  //slt
			 		({ALUOp_i,funct_i} == 9'b010000000) ? 2'b01 :  //sll
					({ALUOp_i,funct_i} == 9'b010000010) ? 2'b01 :  //srl
					({ALUOp_i,funct_i} == 9'b010000110) ? 2'b01 :  //sllv
					({ALUOp_i,funct_i} == 9'b010000100) ? 2'b01 :  //srlv
					2'b00;  //others
endmodule     
