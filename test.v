`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2018 10:38:38
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test
#(parameter N=8)
    (

    );
    
reg [N-1:0] a1, b1;
wire [2*N-1:0] c1;
reg [2*N-1:0] d;

acc_mul #(.N(N)) acc (
    .a(a1),
    .b(b1),
    .c(c1)
    );
    
integer f, number;

initial 
begin
/*
a1 = 143;
b1 = 227;
d = a1*b1;
*/
f = $fopen("mul8x8.txt","w");
for (number=1; number<=10000; number=number+1)
begin
   a1 = {$random}%(2**N);
   b1 = {$random}%(2**N);
   d = a1*b1;
#50;
   $fwrite(f,"%d  ",a1);
   $fwrite(f,"%d  ",b1);
   $fwrite(f,"%d  ",c1);
   $fwrite(f,"%d  ",d);
   $fwrite(f,"\n");
end  

   $fclose(f);
    //$finish;

end 
endmodule