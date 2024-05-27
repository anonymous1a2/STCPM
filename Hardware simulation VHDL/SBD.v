module SBD_TOP(
    input clk,
    input [319:0] Plaintext,
    output reg [319:0] Ciphertext
);

    reg [319:0] reg_in, reg_out;

    Oneround SBD_instance (
        .input_A(reg_in),
        .output_B(reg_out)
    );

    always @(posedge clk) begin
        reg_in <= Plaintext;
        Ciphertext <= reg_out;
    end

endmodule

module Oneround(
input [319:0] input_A,
output [319:0] output_B
);
wire [63:0] n1;
wire [63:0] n2;
wire [63:0] n3;
wire [63:0] n4;
wire [63:0] n5;
wire [63:0] n6;
wire [63:0] n7;
wire [63:0] n8;
wire [63:0] n9;
wire [63:0] n10;
wire [63:0] n11;
wire [63:0] n12;
wire [63:0] n13;
wire [63:0] n14;
wire [63:0] n15;
wire [63:0] n16;
wire [63:0] n17;
wire [63:0] n18;
wire [63:0] n19;
wire [63:0] n20;
wire [63:0] n21;
wire [63:0] n22;
wire [63:0] n23;
wire [63:0] n24;
wire [63:0] n25;
wire [63:0] n26;
wire [63:0] n27;
wire [63:0] n28;
wire [63:0] n29;
wire [63:0] n30;
wire [63:0] n31;
wire [63:0] n32;
wire [63:0] n33;
wire [63:0] n34;
wire [63:0] n35;
wire [63:0] c0 = 240;
assign {n1, n2, n3, n4, n5} = input_A;

assign n6={n1[57:0],n1[63:58]}^{n2[56:0],n2[63:57]}^{n3[51:0],n3[63:52]}^{n4[9:0],n4[63:10]}^{n5[58:0],n5[63:59]};

assign n7=n1^{n2[2:0],n2[63:3]}^{n3[14:0],n3[63:15]}^{n4[50:0],n4[63:51]}^{n5[44:0],n5[63:45]};

assign n8=n6^{n6[27:0],n6[63:28]};

assign n9=n7^{n7[62:0],n7[63:63]};

assign n10=n1^{n9[37:0],n9[63:38]}^{n8[31:0],n8[63:32]};
assign n11={n2[5:0],n2[63:6]}^{n9[40:0],n9[63:41]}^{n8[30:0],n8[63:31]};
assign n12={n3[29:0],n3[63:30]}^{n9[52:0],n9[63:53]}^{n8[25:0],n8[63:26]};
assign n13={n4[37:0],n4[63:38]}^{n9[24:0],n9[63:25]}^{n8[47:0],n8[63:48]};
assign n14={n5[25:0],n5[63:26]}^{n9[18:0],n9[63:19]}^{n8[32:0],n8[63:33]};

assign n15= n10 ^ c0;
assign n16= ~(n15 & n11);
assign n17= ~(n12 & n13);
assign n18= ~(n15 & ~n12 & n14);
assign n19= ~(n14 & ~n15);
assign n20= ~(n11 & ~n12);
assign n21= ~(n14 & ~n11 & n13);
assign n22= ~(n13 & ~n14);
assign n23= ~( (~n11) & (~n15));
assign n24= ~(n13 & ~n12 & n15);
assign n25= ~((~n12) & (~n13));
assign n26= ~((~n14) & n15);
assign n27= ~(n14 & (~n12) & (~n11));
assign n28= ~(n12 & ~n11);
assign n29= ~(n14 & ~n13);
assign n30= ~(n13 & ~n11 & n15);
assign n31= ~(n16 & n17 & n18);
assign n32= ~(n19 & n20 & n21);
assign n33= ~(n22 & n23 & n24);
assign n34= ~(n25 & n26 & n27);
assign n35= ~(n28 & n29 & n30);
assign output_B={n31, n32, n33, n34, n35};
 
endmodule
