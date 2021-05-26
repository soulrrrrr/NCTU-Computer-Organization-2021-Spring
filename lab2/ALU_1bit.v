module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  assign aa = a ^ invertA;
  assign bb = b ^ invertB;

  wire sum;
  Full_adder f(sum, carryOut, carryIn, aa, bb);
  assign result = operation[1] ? (operation[0] ? less : sum) : (operation[0] ? aa|bb : aa&bb);
endmodule