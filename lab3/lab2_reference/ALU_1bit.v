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
  
  wire sum;
  wire A,B;
  wire aand;
  wire aor;

  assign A = (invertA) ? ~a : a ;
  assign B = (invertB) ? ~b : b ;
  
  and and1(aand,A,B) ;
  
  or or1(aor,A,B) ;

  Full_adder add1(sum,carryOut,carryIn,A,B) ;

  assign result= (operation==2'b00) ? aand : (operation==2'b01) ? aor : (operation==2'b10) ? sum : less;
  
endmodule