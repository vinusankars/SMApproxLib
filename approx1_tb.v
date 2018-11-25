`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Indian Institute of Technology Gandhinagar
// Engineer: Vinu Sankar S.
// 
// Create Date: 13.11.2018 20:00:21
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


module test(

    );

reg [7:0] a1, b1;
wire [15:0] c1;
reg [15:0] d;

approx1 app (
    .a(a1),
    .b(b1),
    .c(c1)
    );
    
integer i, j, f;
    
initial 
begin
    f = $fopen("mul8x8_approx1.txt", "w");
    for (i=0; i<=2**8-1; i=i+1)
    begin
        for (j=0; j<=2**8-1; j=j+1)
        begin
            a1 = i;
            b1 = j;
            d = i*j;
            #50
            $fwrite(f, "%d ", a1);
            $fwrite(f, "%d ", b1);
            $fwrite(f, "%d ", c1);
            $fwrite(f, "%d\n", d);
        end
    end
    $fclose(f);
end    
endmodule
