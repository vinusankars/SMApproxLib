`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Indian Institute of Technology Gandhinagar
// Engineer: Vinu Sankar S.
// 
// Create Date: 14.11.2018 10:34:43
// Design Name: 
// Module Name: approx2
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


module approx2(
    input [7:0] a,
    input [7:0] b,
    output [15:0] c
    );
    
wire p1[11:0];
wire p2[11:0];

//Red LUT for layer 1    
LUT6_2 #(
.INIT(64'h7888000078888888) // Specify LUT Contents
)
Red1 (
.O6(p1[1]),
.O5(p1[0]),
.I0(b[0]),   
.I1(a[1]),        
.I2(b[1]),     
.I3(a[0]),        
.I4(1'b1),           
.I5(1'b1)            
); 

//Blue LUT for layer 1
LUT6_2 #(
.INIT(64'h2777C88878887888) // Specify LUT Contents
)
Blue1 (
.O6(p1[2]),
.O5(),
.I0(b[0]),   
.I1(a[2]),        
.I2(b[1]),     
.I3(a[1]),        
.I4(b[2]),           
.I5(a[0])            
);  

//Yellow LUT for layer 1
LUT6_2 #(
.INIT(64'h2777C88878887888) // Specify LUT Contents
)
Yellow1 (
.O6(p1[8]),
.O5(),
.I0(b[1]),   
.I1(a[7]),        
.I2(b[2]),     
.I3(a[6]),        
.I4(b[3]),           
.I5(a[5])            
); 

//Purple LUTs for layer 1
wire l1_12;

LUT6_2 #(
.INIT(64'hAA00000078887888) // Specify LUT Contents
)
Purple1_1 (
.O6(l1_12),
.O5(p1[9]),
.I0(b[3]),   
.I1(a[6]),        
.I2(b[2]),     
.I3(a[7]),        
.I4(1'b1),           
.I5(1'b1)            
); 

LUT6_2 #(
.INIT(64'h800000006A6A6A6A) // Specify LUT Contents
)
Purple1_2 (
.O6(p1[11]),
.O5(p1[10]),
.I0(l1_12),   
.I1(b[3]),        
.I2(a[7]),     
.I3(1'b1),        
.I4(1'b1),           
.I5(1'b1)            
); 


//Red LUT for layer 2 
LUT6_2 #(
.INIT(64'h7888000078888888) // Specify LUT Contents
)
Red2 (
.O6(p2[1]),
.O5(p2[0]),
.I0(b[4]),   
.I1(a[1]),        
.I2(b[5]),     
.I3(a[0]),        
.I4(1'b1),           
.I5(1'b1)            
); 

//Blue LUT for layer 2
LUT6_2 #(
.INIT(64'h2777C88878887888) // Specify LUT Contents
)
Blue2 (
.O6(p2[2]),
.O5(),
.I0(b[4]),   
.I1(a[2]),        
.I2(b[5]),     
.I3(a[1]),        
.I4(b[6]),           
.I5(a[0])            
);  

//Yellow LUT for layer 2
LUT6_2 #(
.INIT(64'h2777C88878887888) // Specify LUT Contents
)
Yellow2 (
.O6(p2[8]),
.O5(),
.I0(b[5]),   
.I1(a[7]),        
.I2(b[6]),     
.I3(a[6]),        
.I4(b[7]),           
.I5(a[5])            
); 

//Purple LUTs for layer 2
wire l2_12;

LUT6_2 #(
.INIT(64'hAA00000078887888) // Specify LUT Contents
)
Purple2_1 (
.O6(l2_12),
.O5(p2[9]),
.I0(b[7]),   
.I1(a[6]),        
.I2(b[6]),     
.I3(a[7]),        
.I4(1'b1),           
.I5(1'b1)            
); 

LUT6_2 #(
.INIT(64'h800000006A6A6A6A) // Specify LUT Contents
)
Purple2_2 (
.O6(p2[11]),
.O5(p2[10]),
.I0(l2_12),   
.I1(b[7]),        
.I2(a[7]),     
.I3(1'b1),        
.I4(1'b1),           
.I5(1'b1)            
); 

//Green LUTs
genvar g;
wire l1_34[0:4];
wire l2_34[0:4];

for (g=0; g<5; g=g+1)
begin
LUT6_2 #(
.INIT(64'h7888000000000000) // Specify LUT Contents
)
    Green1_1 (
    .O6(l1_34[g]),
    .O5(),
    .I0(b[3]),   
    .I1(a[g]),        
    .I2(b[2]),     
    .I3(a[g+1]),        
    .I4(1'b1),           
    .I5(1'b1)            
    ); 
    
    LUT6_2 #(
    .INIT(64'h7888000000000000) // Specify LUT Contents
    )
    Green2_1 (
    .O6(l2_34[g]),
    .O5(),
    .I0(b[7]),   
    .I1(a[g]),        
    .I2(b[6]),     
    .I3(a[g+1]),        
    .I4(1'b1),           
    .I5(1'b1)            
    ); 
    
    LUT6_2 #(
    .INIT(64'h3FC0C0C000000000) // Specify LUT Contents
    )
    Green1_2 (
    .O6(p1[g+3]),
    .O5(),
    .I0(l1_34[g]),   
    .I1(b[1]),        
    .I2(a[g+2]),     
    .I3(b[0]),        
    .I4(a[g+3]),           
    .I5(1'b1)            
    ); 
    
    LUT6_2 #(
    .INIT(64'h3FC0C0C000000000) // Specify LUT Contents
    )
    Green2_2 (
    .O6(p2[g+3]),
    .O5(),
    .I0(l2_34[g]),   
    .I1(b[5]),        
    .I2(a[g+2]),     
    .I3(b[4]),        
    .I4(a[g+3]),           
    .I5(1'b1)            
    ); 

end

//Approximate addition using LUTs
assign c[0] = p1[0];
assign c[1] = p1[1];
assign c[2] = p1[2];
assign c[3] = p1[3];

genvar appr;

for (appr=5; appr<=10; appr=appr+1)
begin
    LUT6_2 #(
    .INIT(64'h8778877866666666) // Specify LUT Contents
    )
    Appr1 (
    .O6(c[appr+1]),
    .O5(),
    .I0(p1[appr]),   
    .I1(p2[appr-4]),        
    .I2(p1[appr+1]),     
    .I3(p2[appr-3]),        
    .I4(1'b1),           
    .I5(1'b1)            
    );
end

LUT6_2 #(
.INIT(64'h8778877866666666) // Specify LUT Contents
)
Appr1_0 (
.O6(c[5]),
.O5(c[4]),
.I0(p1[4]),   
.I1(p2[0]),        
.I2(p1[5]),     
.I3(p2[1]),        
.I4(1'b1),           
.I5(1'b1)            
);

LUT6_2 #(
.INIT(64'h8778877866666666) // Specify LUT Contents
)
Appr1_12 (
.O6(c[12]),
.O5(),
.I0(p1[11]),   
.I1(p2[7]),        
.I2(1'b0),     
.I3(p2[8]),        
.I4(1'b1),           
.I5(1'b1)            
);

LUT6_2 #(
.INIT(64'h8778877866666666) // Specify LUT Contents
)
Appr1_13 (
.O6(c[13]),
.O5(),
.I0(1'b0),   
.I1(p2[8]),        
.I2(1'b0),     
.I3(p2[9]),        
.I4(1'b1),           
.I5(1'b1)            
);

LUT6_2 #(
.INIT(64'h787878787F807F80) // Specify LUT Contents
)
Appr1_14_15 (
.O6(c[15]),
.O5(c[14]),
.I0(1'b0),   
.I1(p2[9]),        
.I2(p2[10]),     
.I3(p2[11]),        
.I4(1'b1),           
.I5(1'b1)            
);

endmodule
