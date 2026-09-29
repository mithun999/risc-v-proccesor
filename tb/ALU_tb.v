`timescale 1ns/1ps
module ALU_tb;
    reg[31:0]a,b;
    reg[3:0]alu_sel;
    wire [31:0] result;
    wire zero;
    
     alu dut (.a(a), .b(b), .alu_sel(alu_sel), .result(result), .zero(zero));

    task check(input [3:0] c, input [31:0] x, input [31:0] y,
               input [31:0] exp, input [127:0] name);
        begin
            alu_sel = c; a = x; b = y; #1;
            if (result !== exp)
                $display("FAIL %0s: got %h, expected %h", name, result, exp);
            else
                $display("PASS %0s", name);
        end
    endtask
    initial begin
        // ADD / SUB
        check(4'b0000, 32'd10, 32'd3,  32'd13,       "add");
        check(4'b0000, 32'hFFFFFFFF,  32'd1,  32'd0,        "add overflow");
        check(4'b0001, 32'd10,32'd3,  32'd7,        "sub");
        check(4'b0001, 32'd3,32'd10, 32'hFFFFFFF9, "sub negative");

        // Shifts
        check(4'b0101, 32'd1,        32'd4,  32'h00000010, "sll");
        check(4'b0101, 32'd1,        32'd33, 32'd2,        "sll amt mod 32");
        check(4'b0110, 32'h80000000, 32'd4,  32'h08000000, "srl");
        check(4'b0111, 32'h80000000, 32'd4,  32'hF8000000, "sra");
        //comparisions
         check(4'b1000, 32'hFFFFFFFF, 32'd1,  32'd1, "slt -1<1");
        check(4'b1000, 32'd1,        32'hFFFFFFFF, 32'd0, "slt 1<-1");
        check(4'b1001, 32'hFFFFFFFF, 32'd1,  32'd0, "sltu max<1");
        check(4'b1001, 32'd1,        32'hFFFFFFFF, 32'd1, "sltu 1<max");

        // Zero flag
        alu_sel = 4'b0001; a = 32'd5; b = 32'd5; #1;
        if (zero !== 1'b1) $display("FAIL zero flag set");
        else               $display("PASS zero flag set");
        a = 32'd5; b = 32'd4; #1;
        if (zero !== 1'b0) $display("FAIL zero flag clear");
        else               $display("PASS zero flag clear");

        $finish;
    end
endmodule //
