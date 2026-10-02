
`timescale 1ns/1ps
module tb_regfile;
    reg         clk = 0;
    reg         we;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] wd;
    wire [31:0] rd1, rd2;

    regfile dut (.clk(clk), .we(we), .rs1(rs1), .rs2(rs2),
                 .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

    always #5 clk = ~clk;   // 10 ns clock

    task write_reg(input [4:0] r, input [31:0] v);
        begin
            we = 1; rd = r; wd = v;
            @(posedge clk); #1;
            we = 0;
        end
    endtask

    task check(input [31:0] got, input [31:0] exp, input [127:0] name);
        begin
            if (got !== exp) $display("FAIL %0s: got %h, expected %h", name, got, exp);
            else             $display("PASS %0s", name);
        end
    endtask

    initial begin
        we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        #12;

        write_reg(5'd5,  32'hDEADBEEF);
        write_reg(5'd10, 32'h12345678);

        rs1 = 5'd5; rs2 = 5'd10; #1;
        check(rd1, 32'hDEADBEEF, "read x5 on port 1");
        check(rd2, 32'h12345678, "read x10 on port 2");

        write_reg(5'd0, 32'hFFFFFFFF);
        rs1 = 5'd0; #1;
        check(rd1, 32'd0, "x0 stays zero");

        we = 0; rd = 5'd5; wd = 32'h0BADF00D;
        @(posedge clk); #1;
        rs1 = 5'd5; #1;
        check(rd1, 32'hDEADBEEF, "no write when we=0");

        $finish;
    end
endmodule