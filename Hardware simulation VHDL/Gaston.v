module Gaston_TOP(
    input clk,
    input [319:0] Plaintext,
    output reg [319:0] Ciphertext
);

    reg [319:0] reg_in, reg_out;

    Oneround Gaston_instance (
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
wire [63:0] c0 = 240;
assign {n1, n2, n3, n4, n5} = input_A;

assign n6={n1[38:0],n1[63:39]}^{n2[35:0],n2[63:36]}^{n3[53:0],n3[63:54]}^{n4[40:0],n4[63:41]}^{n5[60:0],n5[63:61]};

assign n7=n1^{n2[3:0],n2[63:4]}^{n3[41:0],n3[63:42]}^{n4[36:0],n4[63:37]}^{n5[59:0],n5[63:60]};

assign n8=n6^{n6[45:0],n6[63:46]};

assign n9=n7^{n7[62:0],n7[63:63]};

assign n10=n1^{n9[40:0],n9[63:41]}^{n8[40:0],n8[63:41]};
assign n11={n2[11:0],n2[63:12]}^{n9[48:0],n9[63:49]}^{n8[48:0],n8[63:49]};
assign n12={n3[10:0],n3[63:11]}^{n9[9:0],n9[63:10]}^{n8[9:0],n8[63:10]};
assign n13={n4[54:0],n4[63:55]}^{n9[58:0],n9[63:59]}^{n8[58:0],n8[63:59]};
assign n14={n5[16:0],n5[63:17]}^{n9[61:0],n9[63:62]}^{n8[61:0],n8[63:62]};

assign n15= n10 ^ c0;
assign n16= n15^( (~n11)  & n12  ) ;
assign n17= n11^( (~n12)  & n13  ) ;
assign n18= n12^( (~n13)  & n14  ) ;
assign n19= n13^( (~n14)  & n15  ) ;
assign n20= n14^( (~n15)  & n11  ) ;
assign output_B={n16, n17, n18, n19, n20};
 
endmodule
