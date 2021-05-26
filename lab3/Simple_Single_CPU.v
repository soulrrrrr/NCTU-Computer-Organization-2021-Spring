`include "ALU.v"
`include "ALU_Ctrl.v"
`include "Adder.v"
`include "Decoder.v"
`include "Instr_Memory.v"
`include "Mux2to1.v"
`include "Mux3to1.v"
`include "Program_Counter.v"
`include "Reg_File.v"
`include "Shifter.v"
`include "Sign_Extend.v"
`include "Zero_Filled.v"

module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signals
wire	[31: 0]pc_in;
wire	[31: 0]pc_out;
wire	[31: 0]instr_o;
wire	[31: 0]sign_extend;
wire    [31: 0]zero_filled;
wire	RegDst;
wire	RegWrite;
wire	Branch;
wire	[ 2: 0]ALUOp;
wire	ALUSrc;
wire    ALUSrc2;
wire    sllv;
wire	[31: 0]Adder1_o;
wire	[31: 0]Adder2_o;
wire	zero;
wire    overflow;
wire	[31: 0]ALU_result;
wire	[ 4: 0]write_o;
wire	[31: 0]read_data_1;
wire	[31: 0]read_data_2;
wire 	[31: 0]write_data;
wire 	[31: 0]shifted_data;
wire	[ 3: 0]ALUCtrl;
wire    [ 1: 0]FURslt;
wire	[31: 0]ALUSrc_mux;
wire    [0:0]lr;
wire    [4:0] shamt;


//modules
Program_Counter PC(
        .clk_i(clk_i),      
	.rst_n(rst_n),     
	.pc_in_i(pc_in[31:0]),   
	.pc_out_o(pc_out[31:0])
	);
	
Adder Adder1(
        .src1_i(32'd4),     
	.src2_i(pc_out[31:0]),     
	.sum_o(pc_in[31:0])    
	);
	
Instr_Memory IM(
        .pc_addr_i(pc_out[31: 0]),  
	.instr_o(instr_o[31: 0])    
	);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst),
        .data_o(write_o[4:0])
        );
	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(write_o[4:0]) ,  
        .RDdata_i(write_data[31:0]) , 
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data_1[31:0]) ,  
        .RTdata_o(read_data_2[31:0])   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp[2:0]),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
	    );

Mux2to1 #(.size(5)) Mux_SLLV(
        .data0_i(instr_o[10:6]),
        .data1_i(read_data_1[4:0]),
        .select_i(sllv),
        .data_o(shamt[4:0])
        );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALUOp[2:0]),   
        .ALU_operation_o(ALUCtrl[3:0]),
	.FURslt_o(FURslt[1:0]),
        .lr(lr),
        .sllv(sllv)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_extend[31:0])
        );

Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zero_filled[31:0])
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(read_data_2[31:0]),
        .data1_i(sign_extend[31:0]),
        .select_i(ALUSrc),
        .data_o(ALUSrc_mux[31:0])
        );	
		
ALU ALU(
        .aluSrc1(read_data_1[31:0]),
	.aluSrc2(ALUSrc_mux[31: 0]),
	.ALU_operation_i(ALUCtrl[3:0]),
	.result(ALU_result[31:0]),
	.zero(zero),
	.overflow(overflow)
	);
		
Shifter shifter( 
		.result(shifted_data[31:0]), 
		.leftRight(lr),
		.shamt(shamt[4:0]),
		.sftSrc(ALUSrc_mux[31: 0]) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result[31:0]),
        .data1_i(shifted_data[31:0]),
	.data2_i(zero_filled[31:0]),
        .select_i(FURslt[1:0]),
        .data_o(write_data)
        );			

endmodule



