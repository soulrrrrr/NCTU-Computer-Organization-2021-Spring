module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  genvar i;
  
  /*your code here*/
  wire [31:0] car ;
  reg set ;
  wire signed [31:0] A, B;
	/*
  ALU_1bit alu0(result[0],car[0],aluSrc1[0],aluSrc2[0],invertA,invertB,operation,invertB,set) ;
  ALU_1bit alu1(result[1],car[1],aluSrc1[1],aluSrc2[1],invertA,invertB,operation,car[0],0);
  ALU_1bit alu2(result[2],car[2],aluSrc1[2],aluSrc2[2],invertA,invertB,operation,car[1],0);
  ALU_1bit alu3(result[3],car[3],aluSrc1[3],aluSrc2[3],invertA,invertB,operation,car[2],0);
  ALU_1bit alu4(result[4],car[4],aluSrc1[4],aluSrc2[4],invertA,invertB,operation,car[3],0);
  ALU_1bit alu5(result[5],car[5],aluSrc1[5],aluSrc2[5],invertA,invertB,operation,car[4],0);
  ALU_1bit alu6(result[6],car[6],aluSrc1[6],aluSrc2[6],invertA,invertB,operation,car[5],0);
  ALU_1bit alu7(result[7],car[7],aluSrc1[7],aluSrc2[7],invertA,invertB,operation,car[6],0);
  ALU_1bit alu8(result[8],car[8],aluSrc1[8],aluSrc2[8],invertA,invertB,operation,car[7],0);
  ALU_1bit alu9(result[9],car[9],aluSrc1[9],aluSrc2[9],invertA,invertB,operation,car[8],0);
  ALU_1bit alu10(result[10],car[10],aluSrc1[10],aluSrc2[10],invertA,invertB,operation,car[9],0);
  ALU_1bit alu11(result[11],car[11],aluSrc1[11],aluSrc2[11],invertA,invertB,operation,car[10],0);
  ALU_1bit alu12(result[12],car[12],aluSrc1[12],aluSrc2[12],invertA,invertB,operation,car[11],0);
  ALU_1bit alu13(result[13],car[13],aluSrc1[13],aluSrc2[13],invertA,invertB,operation,car[12],0);
  ALU_1bit alu14(result[14],car[14],aluSrc1[14],aluSrc2[14],invertA,invertB,operation,car[13],0);
  ALU_1bit alu15(result[15],car[15],aluSrc1[15],aluSrc2[15],invertA,invertB,operation,car[14],0);
  ALU_1bit alu16(result[16],car[16],aluSrc1[16],aluSrc2[16],invertA,invertB,operation,car[15],0);
  ALU_1bit alu17(result[17],car[17],aluSrc1[17],aluSrc2[17],invertA,invertB,operation,car[16],0);
  ALU_1bit alu18(result[18],car[18],aluSrc1[18],aluSrc2[18],invertA,invertB,operation,car[17],0);
  ALU_1bit alu19(result[19],car[19],aluSrc1[19],aluSrc2[19],invertA,invertB,operation,car[18],0);
  ALU_1bit alu20(result[20],car[20],aluSrc1[20],aluSrc2[20],invertA,invertB,operation,car[19],0);
  ALU_1bit alu21(result[21],car[21],aluSrc1[21],aluSrc2[21],invertA,invertB,operation,car[20],0);
  ALU_1bit alu22(result[22],car[22],aluSrc1[22],aluSrc2[22],invertA,invertB,operation,car[21],0);
  ALU_1bit alu23(result[23],car[23],aluSrc1[23],aluSrc2[23],invertA,invertB,operation,car[22],0);
  ALU_1bit alu24(result[24],car[24],aluSrc1[24],aluSrc2[24],invertA,invertB,operation,car[23],0);
  ALU_1bit alu25(result[25],car[25],aluSrc1[25],aluSrc2[25],invertA,invertB,operation,car[24],0);
  ALU_1bit alu26(result[26],car[26],aluSrc1[26],aluSrc2[26],invertA,invertB,operation,car[25],0);
  ALU_1bit alu27(result[27],car[27],aluSrc1[27],aluSrc2[27],invertA,invertB,operation,car[26],0);
  ALU_1bit alu28(result[28],car[28],aluSrc1[28],aluSrc2[28],invertA,invertB,operation,car[27],0);
  ALU_1bit alu29(result[29],car[29],aluSrc1[29],aluSrc2[29],invertA,invertB,operation,car[28],0);
  ALU_1bit alu30(result[30],car[30],aluSrc1[30],aluSrc2[30],invertA,invertB,operation,car[29],0);
  ALU_1bit alu31(result[31],car[31],aluSrc1[31],aluSrc2[31],invertA,invertB,operation,car[30],0);
	*/
	generate
	for  (i = 0; i < 32; i = i+1)	
	begin
		if(i == 0)
			ALU_1bit alu1(
				.result(result[i]),
				.carryOut(car[i]),
				.a(aluSrc1[i]),
				.b(aluSrc2[i]),
				.invertA(invertA),
				.invertB(invertB),
				.operation(operation),
				.carryIn(invertB),
				.less(set)
			);
		else
			ALU_1bit alu2(
				.result(result[i]),
				.carryOut(car[i]),
				.a(aluSrc1[i]),
				.b(aluSrc2[i]),
				.invertA(invertA),
				.invertB(invertB),
				.operation(operation),
				.carryIn(car[i-1]),
				.less(1'b0)
			);
	end
	endgenerate
  
  assign zero = (result==32'b0) ? 1 : 0 ;
  assign overflow = car[31] ^ car[30] ;
  assign A = (invertA == 1) ? aluSrc1 : aluSrc1;
  assign B = (invertB == 1) ? aluSrc2 : aluSrc2;

  always @ (*)
  begin
		set = aluSrc1[31] ^ (~aluSrc2[31]) ^ car[31];
		//set = aluSrc1[31] ^ (~aluSrc2[31]) ^ car[30] ^ overflow;
  end
  
endmodule