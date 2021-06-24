// author: 0816034 蔡家倫 2021.6.24
module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] instr, PC_i, PC_o, ReadData1, ReadData2, WriteData;
wire [32-1:0] signextend, zerofilled, ALUinput2, ALUResult, ShifterResult;
wire [5-1:0] WriteReg_addr, Shifter_shamt;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOP;
wire [2-1:0] FURslt;
wire [2-1:0] RegDst, MemtoReg;
wire RegWrite, ALUSrc, zero, overflow;
wire Jump, Branch, BranchType, MemWrite, MemRead;
wire [32-1:0] PC_add1, PC_add2, PC_no_jump, PC_t, Mux3_result, DM_ReadData;
wire Jr;
wire PCSrc;
wire mzero_o;
wire [5-1:0] muxwrite_o;
wire [64-1:0] ifid_o;
wire [192-1:0] idex_o;
wire [107-1:0] exmem_o;
wire [71-1:0] memwb_o;
assign Jr = ((instr[31:26] == 6'b000000) && (instr[20:0] == 21'd8)) ? 1 : 0;

//modules
Program_Counter PC(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .pc_in_i(PC_i),
        .pc_out_o(PC_o)
        );

Adder Adder1(//next instruction
        .src1_i(PC_o), 
	.src2_i(32'd4),
	.sum_o(PC_add1)
	);

// always@(PC_o)
// begin
//     $display("p: %b", instr);
//     $display("pc_o: %b", PC_o);
//     $display("pc+4: %b", PC_add1);
// end
		
Adder Adder2(//branch
        .src1_i(idex_o[180:149]),
	.src2_i({idex_o[82:53], 2'b00}),//shift left 2
	.sum_o(PC_add2)
	);


Mux2to1 #(.size(32)) Mux_branch(
        .data0_i(PC_add1),
        .data1_i(exmem_o[101:70]),
        .select_i(exmem_o[104] & exmem_o[69]),
        .data_o(PC_i)
        );
// Mux2to1 #(.size(32)) Mux_branch(
//         .data0_i(PC_add1),
//         .data1_i(PC_add2),
//         .select_i(Branch & (zero ^ BranchType)),
//         .data_o(PC_no_jump)
//         );

always@(ifid_o)
begin
    //$display("pc_add1: %b", PC_add1);
    //$display("pc_add2: %b", PC_add2);
    //$display("pc_i: %b", PC_i);
    //$display("ifid: %b", ifid_o);
end

// Mux2to1 #(.size(32)) Mux_jump(
//         .data0_i(PC_no_jump),
//         .data1_i({PC_add1[31:28], instr[25:0], 2'b00}),//jump address
//         .select_i(Jump),
//         .data_o(PC_t)
//         );
		
// Mux2to1 #(.size(32)) Mux_jr(// deal with jr
//         .data0_i(PC_t),
//         .data1_i(ReadData1),
//         .select_i(Jr),
//         .data_o(PC_i)
//         );

Instr_Memory IM(
        .pc_addr_i(PC_o),
        .instr_o(instr)
        );
// always@(*)
// begin
//      $display("PC_o: %b", PC_o);
// 	$display("instr: %b", instr);
// end
Pipeline_Reg #(.size(64)) IFID( /////////////////////////////////
        .clk_i(clk_i),
	.rst_n(rst_n),
        .data_i({PC_add1, instr}),
        .data_o(ifid_o)
        );
// always@(idex_o)
// begin
//         $display("PC_o: %d", PC_o);
//  	$display("idex: %b", idex_o[192-1:128]);
//         $display("idex: %b", idex_o[128-1:64]);
//         $display("idex: %b", idex_o[64-1:0]);
// end	

Reg_File RF(
        .clk_i(clk_i),
	.rst_n(rst_n),
        .RSaddr_i(ifid_o[25:21]),
        .RTaddr_i(ifid_o[20:16]),
        .Wrtaddr_i(memwb_o[4:0]),
        .Wrtdata_i(WriteData),
        .RegWrite_i(memwb_o[70]),
        .RSdata_o(ReadData1),
        .RTdata_o(ReadData2)
        );

Decoder Decoder(
        .instr_op_i(ifid_o[31:26]),
        .RegWrite_o(RegWrite),
        .ALUOp_o(ALUOP),
        .ALUSrc_o(ALUSrc),
        .RegDst_o(RegDst),
        .Jump_o(Jump),
        .Branch_o(Branch),
        .BranchType_o(BranchType),
        .MemWrite_o(MemWrite),
        .MemRead_o(MemRead),
        .MemtoReg_o(MemtoReg)
        );

ALU_Ctrl AC(
        .funct_i(idex_o[5:0]),///////////
        .ALUOp_i(idex_o[184:182]), 
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt)
        );

	
Sign_Extend SE(
        .data_i(ifid_o[15:0]),
        .data_o(signextend)
        );

Zero_Filled ZF(
        .data_i(ifid_o[15:0]),
        .data_o(zerofilled)
        );
// always@(ifid_o)
// begin
// 	$display("zerofilled: %b", zerofilled);
// end
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(idex_o[116:85]),
        .data1_i(idex_o[84:53]),
        .select_i(idex_o[181]),
        .data_o(ALUinput2)
        );	
/*
Mux2to1 #(.size(32)) Shifter_in( //srl sll sllv srlv
        .data0_i({27'd0,instr[10:6]}),//fill to 32 bit
        .data1_i(ReadData1),
        .select_i(ALU_operation[1]),
        .data_o(Shifter_shamt)
        ); // Shifter_shamt would cause warning(Mux output: 32b, shifter shamt: 5b)
*/

Pipeline_Reg #(.size(192)) IDEX( /////////////////////////////////
        .clk_i(clk_i),
	.rst_n(rst_n),
        .data_i({RegWrite, MemtoReg[0], Branch, MemRead, MemWrite, 
                 RegDst[0], BranchType, ALUOP[2:0], ALUSrc,
                 ifid_o[64-1:32], ReadData1, ReadData2, 
                 signextend, zerofilled, ifid_o[20:0]}),
        .data_o(idex_o)
        );

ALU ALU(
        .aluSrc1(idex_o[148:117]),
        .aluSrc2(ALUinput2),
        .ALU_operation_i(ALU_operation),
        .result(ALUResult),
        .zero(zero),
        .overflow(overflow)
        );
/*always@(*)
begin
	$display("ReadData1: %d", ReadData1);
	$display("ALUinput2: %d", ALUinput2);
	$display("ALUResult: %d", ALUResult);
end*/
Shifter shifter( 
		.result(ShifterResult),
		.leftRight(ALU_operation[0]),
		.shamt(idex_o[10:6]),
		.sftSrc(ALUinput2)
		);

Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALUResult),
        .data1_i(ShifterResult),
	.data2_i(idex_o[52:21]),
        .select_i(FURslt),
        .data_o(Mux3_result)
        );

Mux2to1 #(.size(1)) Mux_zero(
        .data0_i(zero),
        .data1_i(!zero),
        .select_i(idex_o[185]),
        .data_o(mzero_o)
        );

Mux2to1 #(.size(5)) Mux_write(
        .data0_i(idex_o[20:16]),
        .data1_i(idex_o[15:11]),
        .select_i(idex_o[186]),
        .data_o(muxwrite_o)
        );			
/*always@(*)
begin
	$display("ALUResult: %d", ALUResult);
	$display("FURslt: %d", FURslt);
	$display("Mux3_result: %d", Mux3_result);
end*/
Pipeline_Reg #(.size(107)) EXMEM( /////////////////////////////////
        .clk_i(clk_i),
	.rst_n(rst_n),
        .data_i({idex_o[191:187], PC_add2, mzero_o,
                 Mux3_result, idex_o[116:85], muxwrite_o}),
        .data_o(exmem_o)
        );

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(exmem_o[68:37]),
        .data_i(exmem_o[36:5]),
        .MemRead_i(exmem_o[103]),
        .MemWrite_i(exmem_o[102]),
        .data_o(DM_ReadData)
        );
/*always@(*)
begin
	$display("Mux3_result: %d", $signed(Mux3_result));
	$display("ReadData2: %d", $signed(ReadData2));
end*/
Pipeline_Reg #(.size(71)) MEMWB( /////////////////////////////////
        .clk_i(clk_i),
	.rst_n(rst_n),
        .data_i({exmem_o[106:105], DM_ReadData, exmem_o[68:37], exmem_o[4:0]}),
        .data_o(memwb_o)
        );


Mux2to1 #(.size(32)) Mux_Write( 
        .data1_i(memwb_o[68:37]),
        .data0_i(memwb_o[36:5]),
	//.data2_i(PC_add1),//PC+4 consider jal
        .select_i(memwb_o[69]),
        .data_o(WriteData)
        );
/*always@(*)
begin
	$display("WriteData: d", WriteData);
end*/
endmodule



