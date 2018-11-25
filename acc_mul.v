`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Indian Institute of Technology Gandhinagar
// Author: Vinu Sankar Sadasivan
// 
// Create Date: 07.11.2018 13:57:44
// Design Name: 
// Module Name: acc_mul
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


module acc_mul
#(parameter N = 8)
    (
    input [N-1:0] a,
    input [N-1:0] b,
    output [2*N-1:0] c
    );
    
    wire col[1:N-1][1:N];
    wire row[1:N-1][1:N/4];
    wire out[1:N-1][1:N][0:1];
    wire temp;
    wire temp3[1:14] ,temp2[1:14] ,temp1[1:14];
    
    genvar index1, index2;    
    genvar t1_1;
    genvar t2_1;
    genvar t2_2;
    genvar t2_3;
    genvar t2_4;
    genvar t3;
    genvar c_1;
    genvar c_2;   
    
    //Row 1 and 2 of partial products summing with T1
    for (t1_1=1; t1_1<N; t1_1=t1_1+1)
    begin    
        LUT6_2 #(
        .INIT(64'h7888000080000000) // Specify LUT Contents
        )
        T1 (
        .O6(out[1][t1_1][0]),
        .O5(out[1][t1_1][1]),
        .I0(a[t1_1-1]),   
        .I1(b[1]),        
        .I2(a[t1_1]),     
        .I3(b[0]),        
        .I4(1'b1),           
        .I5(1'b1)            
        );
    end
    
    LUT6_2 #(
    .INIT(64'h7888000080000000) // Specify LUT Contents
    )
    T1 (
    .O6(out[1][N][0]),
    .O5(out[1][N][1]),
    .I0(a[N-2]),   
    .I1(b[2]),        
    .I2(a[N-1]),     
    .I3(b[1]),        
    .I4(1'b1),           
    .I5(1'b1)            
    );
    
    //Row i partial product summing with T2 - Part 1
    for(t2_1=2; t2_1<N; t2_1=t2_1+1)
    begin
        for(t2_2=0; t2_2<N-t2_1; t2_2=t2_2+1)
        begin
            LUT6_2 #(
                .INIT(64'h7800000080000000) // Specify LUT Contents
                )
                T2 (
                .O6(out[t2_1][t2_2+1][0]),
                .O5(out[t2_1][t2_2+1][1]),
                .I0(a[t2_2]),   
                .I1(b[t2_1]),        
                .I2(col[t2_1-1][t2_2+2]),     
                .I3(1'b1),        
                .I4(1'b1),           
                .I5(1'b1)            
                );
        end
    end
    
    //Row i partial product summing with T2 - Part 2
    for(t2_3=2; t2_3<N; t2_3=t2_3+1)
    begin
        for(t2_4=N-t2_3+1; t2_4<N; t2_4=t2_4+1)
        begin
            if (t2_4<N-1)
            begin
                LUT6_2 #(
                    .INIT(64'h7800000080000000) // Specify LUT Contents
                    )
                    T2 (
                    .O6(out[t2_3][t2_4+1][0]),
                    .O5(out[t2_3][t2_4+1][1]),
                    .I0(a[t2_4]),   
                    .I1(b[t2_3]),        
                    .I2(col[t2_3-1][t2_4+2]),     
                    .I3(1'b1),        
                    .I4(1'b1),           
                    .I5(1'b1)            
                    );
             end
                
             else
             begin
                 LUT6_2 #(
                 .INIT(64'h7800000080000000) // Specify LUT Contents
                 )
                 T2 (
                 .O6(out[t2_3][N][0]),
                 .O5(out[t2_3][N][1]),
                 .I0(a[t2_4]),   
                 .I1(b[t2_3]),        
                 .I2(row[t2_3-1][N/4]),     
                 .I3(1'b1),        
                 .I4(1'b1),           
                 .I5(1'b1)            
                 );
             end
        end
    end
    
    //Row N-1 of partial products summing with T2 to use with T3
    for (t3=3; t3<N; t3=t3+1)
    begin    
        LUT6_2 #(
        .INIT(64'h7800000080000000) // Specify LUT Contents
        )
        T2 (
        .O6(out[t3-1][N-t3+2][0]),
        .O5(out[t3-1][N-t3+2][1]),
        .I0(a[N-t3]),   
        .I1(b[t3]),        
        .I2(col[t3-2][N-t3+3]),     
        .I3(1'b1),        
        .I4(1'b1),           
        .I5(1'b1)            
        );
    end    
    
    //Combining with T3 ro get P_0 and P_N
    LUT6_2 #(
    .INIT(64'hF000000088000000) // Specify LUT Contents
    )
    T3 (
    .O6(out[N-1][2][0]),
    .O5(out[N-1][2][1]),
    .I0(a[0]),   
    .I1(b[0]),        
    .I2(col[N-2][3]),     
    .I3(1'b1),        
    .I4(1'b1),           
    .I5(1'b1)            
    );
    
    //Carry chains
    for (c_1=1; c_1<N; c_1=c_1+1)
    begin
        for(c_2=1; c_2<N+1; c_2=c_2+4)
        begin                    
                       
            if (c_1==N-1 & c_2==1)
            begin
            CARRY4 Carry1(
            .CO({row[c_1][(c_2+3)/4],temp3[(c_1-1)*2+(c_2-1)/4+1],temp2[(c_1-1)*2+(c_2-1)/4+1],temp1[(c_1-1)*2+(c_2-1)/4+1]}),
            .O({col[c_1][c_2+3],col[c_1][c_2+2],col[c_1][c_2+1],col[c_1][c_2]}),
            .CI(),
            .CYINIT(1'b0),
            .DI({out[c_1][c_2+3][1],out[c_1][c_2+2][1],1'b0,out[c_1][c_2][1]}),
            .S({out[c_1][c_2+3][0],out[c_1][c_2+2][0],out[c_1][c_2+1][0],out[c_1][c_2][0]})
            );
            end
            
            else if (c_2==1)
            begin
            CARRY4 Carry2(
            .CO({row[c_1][(c_2+3)/4],temp3[(c_1-1)*2+(c_2-1)/4+1],temp2[(c_1-1)*2+(c_2-1)/4+1],temp1[(c_1-1)*2+(c_2-1)/4+1]}),
            .O({col[c_1][c_2+3],col[c_1][c_2+2],col[c_1][c_2+1],col[c_1][c_2]}),
            .CI(),
            .CYINIT(1'b0),
            .DI({out[c_1][c_2+3][1],out[c_1][c_2+2][1],out[c_1][c_2+1][1],out[c_1][c_2][1]}),
            .S({out[c_1][c_2+3][0],out[c_1][c_2+2][0],out[c_1][c_2+1][0],out[c_1][c_2][0]})
            );
            end
            
            else    
            begin
            CARRY4 Carry3(
            .CO({row[c_1][(c_2+3)/4],temp3[(c_1-1)*2+(c_2-1)/4+1],temp2[(c_1-1)*2+(c_2-1)/4+1],temp1[(c_1-1)*2+(c_2-1)/4+1]}),
            .O({col[c_1][c_2+3],col[c_1][c_2+2],col[c_1][c_2+1],col[c_1][c_2]}),
            .CI(row[c_1][(c_2-1)/4]),
            .CYINIT(),
            .DI({out[c_1][c_2+3][1],out[c_1][c_2+2][1],out[c_1][c_2+1][1],out[c_1][c_2][1]}),
            .S({out[c_1][c_2+3][0],out[c_1][c_2+2][0],out[c_1][c_2+1][0],out[c_1][c_2][0]})
            );
            end     
        end
    end
    
    //Get product
    for (index1=1; index1<N; index1=index1+1)
    begin
        assign c[index1] = col[index1][1];
    end
    
    for (index2=2; index2<N+1; index2=index2+1)
    begin
        assign c[index2+N-2] = col[N-1][index2];
    end
    

    assign c[0] = out[N-1][2][1];
    assign c[2*N-1] = row[N-1][N/4];
        
endmodule