module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  /*your code here*/
	wire [32:0] carryOut;
  assign carryOut[0] = invertB;
  genvar idx;
  generate
    for (idx = 1; idx < 31; idx = idx + 1) begin
      ALU_1bit f (result[idx], carryOut[idx+1], aluSrc1[idx], aluSrc2[idx], invertA, invertB, operation, carryOut[idx], 1'b0);
    end
  endgenerate
  inout wire set;
  ALU_msb m (set, result[31], carryOut[32], aluSrc1[31], aluSrc2[31], invertA, invertB, operation, carryOut[31], 1'b0);
  ALU_1bit ff (result[0], carryOut[1], aluSrc1[0], aluSrc2[0], invertA, invertB, operation, carryOut[0], set);
  assign overflow = operation[1] ? carryOut[32] ^ carryOut[31] : 1'b0;
  assign zero = result ? 1'b0 : 1'b1;
endmodule