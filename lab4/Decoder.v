module Decoder( instr_op_i, instr_fn_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o
			   , Branch_o, BranchType_o, MemWrite_o, MemRead_o
			   , MemtoReg_o, Jump_o, Jr_o);
     
//I/O ports
input	[6-1:0] instr_op_i;
input	[6-1:0] instr_fn_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[2-1:0] RegDst_o;
output 			Branch_o;
output 	[2-1:0]	BranchType_o;
output 			MemWrite_o;
output 			MemRead_o;
output 	[2-1:0] MemtoReg_o;
output 			Jump_o;
output 			Jr_o;	
 
//Internal Signals
reg	[3-1:0] ALUOp_o;
reg			ALUSrc_o;
reg			RegWrite_o;
reg	[2-1:0] RegDst_o;
reg 		Branch_o;
reg [2-1:0]	BranchType_o;
reg 		MemWrite_o;
reg 		MemRead_o;
reg [2-1:0] MemtoReg_o;
reg			Jump_o;
reg 		Jr_o;

//Main function
	/*
assign RegWrite_o = (instr_op_i == 6'b000000) ? 1'b1 :
		    (instr_op_i == 6'b001000) ? 1'b1 : 1'b0;
assign ALUOp_o = (instr_op_i == 6'b000000) ? 3'b010 :
		 (instr_op_i == 6'b001000) ? 3'100 : 3'b000;
assign ALUSrc_o = (instr_op_i == 6'b000000) ? 1'b0 :
		 (instr_op_i == 6'b001000) ? 1'b1 : 1'b0;
assign RegDst_o = (instr_op_i == 6'b000000) ? 1'b1 :
		 (instr_op_i == 6'b001000) ? 1'b0 : 1'b0;*/

always @ (*) begin
	if(instr_op_i == 6'b000000 & instr_fn_i == 6'b001000)begin // jr
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b000; //x:jump
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b1;
		Jr_o <= 1'b1;
    end
    else if(instr_op_i == 6'b000000)begin //r
		RegWrite_o <= 1'b1;
		ALUOp_o <= 3'b010; //2:rformat
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b01;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
    if(instr_op_i == 6'b001000)begin
		RegWrite_o <= 1'b1;
		ALUOp_o <= 3'b100; //4:addi
		ALUSrc_o <= 1'b1;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b101100)begin // lw
		RegWrite_o <= 1'b1;
		ALUOp_o <= 3'b000; //0:lw, sw
		ALUSrc_o <= 1'b1;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b1;
		MemtoReg_o <= 2'b01;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b101101)begin // sw
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b000; //0:lw, sw
		ALUSrc_o <= 1'b1;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b1;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b001010)begin // beq
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b001; //1:beq
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b1;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b001011 || instr_op_i == 6'b001100)begin // bne == bnez
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b110; //6:bne
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b1;
		BranchType_o <= 2'b01;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b000010)begin // jump
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b000; //x:jump
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b1;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b000011)begin // jal
		RegWrite_o <= 1'b1;
		ALUOp_o <= 3'b000; //x:jump
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b10; // jal 31
		Branch_o <= 1'b0;
		BranchType_o <= 2'b00;
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b10;
		Jump_o <= 1'b1;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b001110)begin // blt
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b011; //3:compare
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b1;
		BranchType_o <= 2'b10; //2:blt (self implemented
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
	if(instr_op_i == 6'b001101)begin // bgez
		RegWrite_o <= 1'b0;
		ALUOp_o <= 3'b011; //3:compare
		ALUSrc_o <= 1'b0;
		RegDst_o <= 2'b00;
		Branch_o <= 1'b1;
		BranchType_o <= 2'b11; //3: bgez (self implemented
		MemWrite_o <= 1'b0;
		MemRead_o <= 1'b0;
		MemtoReg_o <= 2'b00;
		Jump_o <= 1'b0;
		Jr_o <= 1'b0;
    end
end


endmodule
   