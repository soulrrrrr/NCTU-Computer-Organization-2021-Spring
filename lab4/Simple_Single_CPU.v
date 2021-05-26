module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] add_pc;
wire [32-1:0] pc_inst;
wire [32-1:0] instr_o;
wire [5-1:0] Write_reg;
wire [2-1:0] RegDst;
wire RegWrite;
wire [3-1:0] ALUOp;
wire ALUSrc;
wire [32-1:0] Write_Data;
wire [32-1:0] rs_data;
wire [32-1:0] rt_data;
wire [4-1:0] ALUCtrl;
wire [2-1:0] FURslt;
wire [32-1:0] sign_instr;
wire [32-1:0] zero_instr;
wire [32-1:0] Src_ALU_Shifter;
wire zero;
wire less;
wire [32-1:0] result_ALU;
wire [32-1:0] result_Shifter;
wire overflow;
wire [5-1:0] ShamtSrc;
wire Jump;
wire Branch;
wire [2-1:0] BranchType;
wire MemWrite;
wire MemRead;
wire [2-1:0] MemtoReg;
wire [32-1:0] branchAdd;
wire PCSrc;
wire [32-1:0] BranchSrc;
wire [32-1:0] JumpSrc;
wire [32-1:0] JrSrc;
wire [32-1:0] Read_Data;
wire [32-1:0] Data_Add;
wire ad;
wire Jal;

//modules
Program_Counter PC(
        .clk_i(clk_i),      
        .rst_n(rst_n),     
        .pc_in_i(JrSrc),   
        .pc_out_o(pc_inst) 
        );
	
Adder Adder1(
        .src1_i(pc_inst),     
        .src2_i(32'd4),
        .sum_o(add_pc)    
        );

Adder Adder2( //branch
        .src1_i(add_pc),     
        .src2_i(sign_instr<<2),
        .sum_o(branchAdd)    
        );

and G(ad, Branch, PCSrc);

Mux2to1 #(.size(32)) toBranch(
        .data0_i(add_pc),
        .data1_i(branchAdd),
        .select_i(ad),
        .data_o(BranchSrc)
        );

Mux2to1 #(.size(32)) toJump(
        .data0_i(BranchSrc),
        .data1_i({add_pc[31:28], instr_o[25:0], 2'b0}),
        .select_i(Jump),
        .data_o(JumpSrc)
        );

Mux2to1 #(.size(32)) toJr(
        .data0_i(JumpSrc),
        .data1_i(rs_data),
        .select_i(Jr),
        .data_o(JrSrc)
        );
	
Instr_Memory IM(
        .pc_addr_i(pc_inst),  
        .instr_o(instr_o)    
        );

Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .data2_i(5'b11111),//31
        .select_i(RegDst),
        .data_o(Write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n),     
        .RSaddr_i(instr_o[25:21]),  
        .RTaddr_i(instr_o[20:16]),  
        .RDaddr_i(Write_reg),  
        .RDdata_i(Write_Data), 
        .RegWrite_i(RegWrite),
        .RSdata_o(rs_data),  
        .RTdata_o(rt_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[32-1:26]),
        .instr_fn_i(instr_o[6-1:0]), 
        .RegWrite_o(RegWrite), 
        .ALUOp_o(ALUOp),   
        .ALUSrc_o(ALUSrc),   
        .RegDst_o(RegDst),
        .Branch_o(Branch),
        .BranchType_o(BranchType),
        .MemWrite_o(MemWrite),
        .MemRead_o(MemRead),
        .MemtoReg_o(MemtoReg),
        .Jump_o(Jump),
        .Jr_o(Jr)
	);

ALU_Ctrl AC(
        .funct_i(instr_o[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALUCtrl),
	.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_instr)
        );

Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zero_instr)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rt_data),
        .data1_i(sign_instr),
        .select_i(ALUSrc),
        .data_o(Src_ALU_Shifter)
        );	

Mux2to1 #(.size(5)) Shamt_Src(
        .data0_i(instr_o[10:6]),
        .data1_i(rs_data[5-1:0]),
        .select_i(ALUCtrl[1]),
        .data_o(ShamtSrc)
        );	

ALU ALU(
        .aluSrc1(rs_data),
        .aluSrc2(Src_ALU_Shifter),
        .ALU_operation_i(ALUCtrl),
        .result(result_ALU),
        .zero(zero),
        .less(less),
        .overflow(overflow)
        );

Mux4to1 #(.size(1)) zero_less_Src(
        .data0_i(zero),
        .data1_i(~zero),
        .data2_i(less),
        .data3_i(~less),
        .select_i(BranchType),
        .data_o(PCSrc)
        );
		
Shifter shifter( 
        .result(result_Shifter), 
        .leftRight(ALUCtrl[0]),
        .shamt(ShamtSrc),
        .sftSrc(Src_ALU_Shifter) 
        );
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(result_ALU),
        .data1_i(result_Shifter),
	.data2_i(zero_instr),
        .select_i(FURslt),
        .data_o(Data_Add)
        );


Data_Memory DM(
        .clk_i(clk_i),      
        .addr_i(Data_Add),
        .data_i(rt_data),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(Read_Data)
        );

Mux3to1 #(.size(32)) DecideRegWrite(
        .data0_i(Data_Add),
        .data1_i(Read_Data),
        .data2_i(add_pc),
        .select_i(MemtoReg),
        .data_o(Write_Data)
        );	

endmodule



