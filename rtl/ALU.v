module alu(input [31:0] a,input [31:0] b,input  [3:0] alu_sel,
    output reg [31:0] result,output wire zero);
 localparam ADD  = 4'b0000,//local param is only in this file these parameters exist
               SUB  = 4'b0001,
               AND_ = 4'b0010,
               OR_  = 4'b0011,
               XOR_ = 4'b0100,
               SLL  = 4'b0101,
               SRL  = 4'b0110,
               SRA  = 4'b0111,
               SLT  = 4'b1000,
               SLTU = 4'b1001;

    always@(*)begin
        case(alu_sel)
        ADD:result=a+b;
        SUB:result=a-b;
        AND_:result=a&b;
        OR_:result=a|b;
        XOR_:result=a^b;
        SLL:result=a<<b[4:0];
        SRL:result=a>>b[4:0];
        SRA:result= $signed(a) >>> b[4:0];
        SLT:result=($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        SLTU:    result = (a < b) ? 32'd1 : 32'd0;
        default:result=32'd0;
        endcase
    end
    assign zero=(result==32'd0);
endmodule
