`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Indian Institute of Technology Gandhinagar
// Engineer: Vinu Sankar S.
// 
// Create Date: 09.11.2018 19:40:59
// Design Name: 
// Module Name: approx1
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


module approx1
    (
    input [7:0] a,
    input [7:0] b,
    output [15:0] c
    );
   
wire out12[1:4][1:8][1:2];
wire carry12[1:4][1:8];
wire pp1[1:4][0:9];
wire pp2[1:2][0:11];
wire pp[15:0];

genvar r1, r2, r3; 
genvar c1;
genvar a1, a2, a3;
    
//All consecutive rows multiplied and added accurately
for (r1=0; r1<8; r1=r1+2)
begin
    for (r2=1; r2<=8; r2=r2+1)
    begin
        if (r2==8)
        begin
            LUT6_2 #(
            .INIT(64'h7888000080000000) // Specify LUT Contents
            )
            T1_partials (
            .O6(out12[r1/2+1][r2][2]),
            .O5(out12[r1/2+1][r2][1]),
            .I0(1'b0),   
            .I1(1'b0),        
            .I2(a[7]),     
            .I3(b[r1+1]),        
            .I4(1'b1),           
            .I5(1'b1)            
            );  
        end
        
        else
        begin
            LUT6_2 #(
            .INIT(64'h7888000080000000) // Specify LUT Contents
            )
            T1_partials (
            .O6(out12[r1/2+1][r2][2]),
            .O5(out12[r1/2+1][r2][1]),
            .I0(a[r2]),   
            .I1(b[r1]),        
            .I2(a[r2-1]),     
            .I3(b[r1+1]),        
            .I4(1'b1),           
            .I5(1'b1)            
            );  
        end  
    end
end

for (c1=1; c1<=4; c1=c1+1)
begin
    CARRY4 carry12_1 (
    .CO({carry12[c1][4],carry12[c1][3],carry12[c1][2],carry12[c1][1]}),
    .O({pp1[c1][4],pp1[c1][3],pp1[c1][2],pp1[c1][1]}),
    .CI(),
    .CYINIT(1'b0),
    .DI({out12[c1][4][1],out12[c1][3][1],out12[c1][2][1],out12[c1][1][1]}),
    .S({out12[c1][4][2],out12[c1][3][2],out12[c1][2][2],out12[c1][1][2]})
    );
    
    CARRY4 carry12_2 (
    .CO({carry12[c1][8],carry12[c1][7],carry12[c1][6],carry12[c1][5]}),
    .O({pp1[c1][8],pp1[c1][7],pp1[c1][6],pp1[c1][5]}),
    .CI(carry12[c1][4]),
    .CYINIT(),
    .DI({out12[c1][8][1],out12[c1][7][1],out12[c1][6][1],out12[c1][5][1]}),
    .S({out12[c1][8][2],out12[c1][7][2],out12[c1][6][2],out12[c1][5][2]})
    );
    
    assign pp1[c1][9] = carry12[c1][8];
end

//1st bit of partial products
for (r3=1; r3<=4; r3=r3+1)
begin
    LUT6_2 #(
    .INIT(64'h7888000080000000) // Specify LUT Contents
    )
    T1_0 (
    .O6(pp1[r3][0]),
    .O5(),
    .I0(a[0]),   
    .I1(b[(r3-1)*2]),        
    .I2(1'b0),     
    .I3(1'b0),        
    .I4(1'b1),           
    .I5(1'b1)            
    );  
    
end

//1st level of partial approximate summing without carry chain
for (a2=1; a2<=2; a2=a2+1)
begin
    for (a1=2; a1<=9; a1=a1+1)
    begin
        if (a1==9)
        begin
            LUT6_2 #(
            .INIT(64'h787878787F807F80) // Specify LUT Contents
            )
            App1_1 (
            .O6(pp2[a2][11]),
            .O5(pp2[a2][10]),
            .I0(pp1[a2*2-1][a1]),   
            .I1(pp1[a2*2][a1-2]),        
            .I2(pp1[a2*2][a1-1]),     
            .I3(pp1[a2*2][a1]),        
            .I4(1'b1),           
            .I5(1'b1)            
            );
        end
        
        else if (a1==2)
        begin
            LUT6_2 #(
            .INIT(64'h8778877866666666) // Specify LUT Contents
            )
            App1_1 (
            .O6(pp2[a2][3]),
            .O5(pp2[a2][2]),
            .I0(pp1[a2*2-1][a1]),   
            .I1(pp1[a2*2][a1-2]),        
            .I2(pp1[a2*2-1][a1+1]),     
            .I3(pp1[a2*2][a1-1]),        
            .I4(1'b1),           
            .I5(1'b1)            
            );
        end
    
        else
        begin
            LUT6_2 #(
            .INIT(64'h8778877866666666) // Specify LUT Contents
            )
            App1_1 (
            .O6(pp2[a2][a1+1]),
            .O5(),
            .I0(pp1[a2*2-1][a1]),   
            .I1(pp1[a2*2][a1-2]),        
            .I2(pp1[a2*2-1][a1+1]),     
            .I3(pp1[a2*2][a1-1]),        
            .I4(1'b1),           
            .I5(1'b1)            
            );
        end
    end
end

assign pp2[1][0] = pp1[1][0];
assign pp2[2][0] = pp1[3][0];
assign pp2[1][1] = pp1[1][1];
assign pp2[2][1] = pp1[3][1];

//The final layer of approximation for getting answer
assign c[0] = pp2[1][0];
assign c[1] = pp2[1][1];
assign c[2] = pp2[1][2];
assign c[3] = pp2[1][3];

for (a3=4; a3<=10; a3=a3+1)
begin
if (a3==4)
begin
    LUT6_2 #(
    .INIT(64'h8778877866666666) // Specify LUT Contents
    )
    App1_2 (
    .O6(c[a3+1]),
    .O5(c[a3]),
    .I0(pp2[1][a3]),   
    .I1(pp2[2][a3-4]),        
    .I2(pp2[1][a3+1]),     
    .I3(pp2[2][a3-3]),        
    .I4(1'b1),           
    .I5(1'b1)               
    );
end

else
begin
    LUT6_2 #(
    .INIT(64'h8778877866666666) // Specify LUT Contents
    )
    App1_2 (
    .O6(c[a3+1]),
    .O5(),
    .I0(pp2[1][a3]),   
    .I1(pp2[2][a3-4]),        
    .I2(pp2[1][a3+1]),     
    .I3(pp2[2][a3-3]),        
    .I4(1'b1),           
    .I5(1'b1)               
    );
end
end

LUT6_2 #(
.INIT(64'h8778877866666666) // Specify LUT Contents
)
App1_3 (
.O6(c[12]),
.O5(),
.I0(pp2[1][11]),   
.I1(pp2[2][7]),        
.I2(1'b0),     
.I3(pp2[2][8]),        
.I4(1'b1),           
.I5(1'b1)               
);

LUT6_2 #(
.INIT(64'h8778877866666666) // Specify LUT Contents
)
App1_4 (
.O6(c[13]),
.O5(),
.I0(1'b0),   
.I1(pp2[2][8]),        
.I2(1'b0),     
.I3(pp2[2][9]),        
.I4(1'b1),           
.I5(1'b1)               
);

LUT6_2 #(
.INIT(64'h787878787F807F80) // Specify LUT Contents
)
App1_5 (
.O6(c[15]),
.O5(c[14]),
.I0(1'b0),   
.I1(pp2[2][9]),        
.I2(pp2[2][10]),     
.I3(pp2[2][11]),        
.I4(1'b1),           
.I5(1'b1)               
);


endmodule
