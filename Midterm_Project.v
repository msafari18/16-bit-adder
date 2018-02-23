
module fulladder (Sum,Cout,a,b,c);
   input a,b,c;
   output Sum,Cout;
   wire S1,D1,D2; 
   xor #(2) xgate1(S1,a,b);
   and #(2) agate1(D1,a,b);
   xor #(2) xgate2(Sum,S1,c);
   and #(2) agate2(D2,S1,c);
   or  #(2) gate(Cout,D2,D1);
endmodule
  
module Adder1_16bit(S,Cout,A,B,Cin);
    input [15:0]A;
    input [15:0]B;
    input Cin;
    output [15:0]S;
    output Cout;  
    wire [14:0]w;
    
    fulladder FAdder1(S[0],w[0],A[0],B[0],Cin),
              FAdder2(S[1],w[1],A[1],B[1],w[0]),
              FAdder3(S[2],w[2],A[2],B[2],w[1]),
              FAdder4(S[3],w[3],A[3],B[3],w[2]),
              FAdder5(S[4],w[4],A[4],B[4],w[3]),
              FAdder6(S[5],w[5],A[5],B[5],w[4]),
              FAdder7(S[6],w[6],A[6],B[6],w[5]),
              FAdder8(S[7],w[7],A[7],B[7],w[6]),
              FAdder9(S[8],w[8],A[8],B[8],w[7]),
              FAdder10(S[9],w[9],A[9],B[9],w[8]),
              FAdder11(S[10],w[10],A[10],B[10],w[9]),
              FAdder12(S[11],w[11],A[11],B[11],w[10]),
              FAdder13(S[12],w[12],A[12],B[12],w[11]),
              FAdder14(S[13],w[13],A[13],B[13],w[12]),
              FAdder15(S[14],w[14],A[14],B[14],w[13]),
              FAdder16(S[15],Cout,A[15],B[15],w[14]);
  endmodule
            
  
  module CLA_4bit(Sum,Cout,Cin,a,b);
    input [3:0]a;
    input [3:0]b;
    input Cin;
    output [3:0]Sum;
    output Cout;
    
    wire [3:0]p;
    wire [3:0]g;
    wire [3:1]c;
    wire [9:0]aw;
    
    xor #(2)
        xgate1(p[0],a[0],b[0]),
        xgate2(p[1],a[1],b[1]),
        xgate3(p[2],a[2],b[2]),
        xgate4(p[3],a[3],b[3]);
    
    and #(2)
        gate1(g[0],a[0],b[0]),
        gate2(g[1],a[1],b[1]),
        gate3(g[2],a[2],b[2]),
        gate4(g[3],a[3],b[3]);
    
    and #(2)
        agate1(aw[0],p[0],Cin),
        agate2(aw[1],p[1],g[0]),
        agate3(aw[2],p[1],aw[0]),
        agate4(aw[3],p[2],g[1]),
        agate5(aw[4],p[2],aw[1]),
        agate6(aw[5],p[2],aw[2]),
        agate7(aw[6],p[3],g[2]),
        agate8(aw[7],p[3],aw[3]),
        agate9(aw[8],p[3],aw[4]),
        agate10(aw[9],p[3],aw[5]);
        
    or #(2) or1(c[1],g[0],aw[0]);
    or #(3) or2(c[2],g[1],aw[1],aw[2]);
    or #(4) or3(c[3],g[2],aw[3],aw[4],aw[5]);
    or #(5) or4(Cout,g[3],aw[6],aw[7],aw[8],aw[9]);
       
    xor #(2)
        s1(Sum[0],p[0],Cin),
        s2(Sum[1],p[1],c[1]),
        s3(Sum[2],p[2],c[2]),
        s4(Sum[3],p[3],c[3]);
          
endmodule

module Adder2_16bit(S,Cout,A,B,Cin);
    input [15:0]A;
    input [15:0]B;
    input Cin;
    output [15:0]S;
    output Cout;
    wire [3:1]w;
    CLA_4bit CLA1(S[3:0],w[1],Cin,A[3:0],B[3:0]),
             CLA2(S[7:4],w[2],w[1],A[7:4],B[7:4]),
             CLA3(S[11:8],w[3],w[2],A[11:8],B[11:8]),
             CLA4(S[15:12],Cout,w[3],A[15:12],B[15:12]);    
  endmodule
      
      
  //testbench
  
  module Adder16_TB;
    reg [15:0]A;
    reg [15:0]B;
    wire [15:0]sum1;
    wire [15:0]sum2;
    wire cout1,cout2;
    
  Adder1_16bit adder1 (sum1,cout1,A,B,1'b0);
  Adder2_16bit adder2 (sum2,cout2,A,B,1'b0);
        
        initial
          begin
           #1
            A=16'b0000000000000000;
            B=16'b0000000000000000; 
            //$display("A =%d B = %d sum1=%d cout1=%d",A,B,sum1,cout1);
            #199
            A=16'b0010010011010111;
            B=16'b0000010000010100; 
            //$display("A =%d B = %d sum1=%d cout1=%d",A,B,sum1,cout1);
            #200
                      
            A=16'b1111110111101000;
            B=16'b0000010000010100; 
            //$display("A =%d B = %d sum1=%d cout1=%d",A,B,sum1,cout1);
            #200
            $stop; 
          end
          initial
          $monitor("sum1 = %d cout1 = %d  sum2= %d cout2=%d",sum1, cout1,sum2,cout2);
    
endmodule

          
    




