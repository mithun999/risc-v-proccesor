// tb/alu_decoder_tb.v
module alu_decoder_tb;
    reg  [1:0] alu_op;
    reg  [2:0] funct3;
    reg        funct7_5;
    wire [3:0] alu_sel;

    alu_decoder dut (.alu_op(alu_op), .funct3(funct3),
                     .funct7_5(funct7_5), .alu_sel(alu_sel));

    initial begin
        // loads/stores: always ADD, even if funct3 looks like something else
        alu_op = 2'b00; funct3 = 3'b010; funct7_5 = 0; #1;
        if (alu_sel == 4'b0000) $display("PASS force add");
        else $display("FAIL force add: got %b", alu_sel);

        // R-type add
        alu_op = 2'b10; funct3 = 3'b000; funct7_5 = 0; #1;
        if (alu_sel == 4'b0000) $display("PASS add");
        else $display("FAIL add: got %b", alu_sel);

        // R-type sub
        alu_op = 2'b10; funct3 = 3'b000; funct7_5 = 1; #1;
        if (alu_sel == 4'b0001) $display("PASS sub");
        else $display("FAIL sub: got %b", alu_sel);

        // I-type addi with bit 30 set (negative immediate): must stay ADD
        alu_op = 2'b11; funct3 = 3'b000; funct7_5 = 1; #1;
        if (alu_sel == 4'b0000) $display("PASS addi negative imm");
        else $display("FAIL addi negative imm: got %b", alu_sel);

        // shifts
        alu_op = 2'b10; funct3 = 3'b101; funct7_5 = 0; #1;
        if (alu_sel == 4'b0110) $display("PASS srl");
        else $display("FAIL srl: got %b", alu_sel);

        alu_op = 2'b10; funct3 = 3'b101; funct7_5 = 1; #1;
        if (alu_sel == 4'b0111) $display("PASS sra");
        else $display("FAIL sra: got %b", alu_sel);

        alu_op = 2'b11; funct3 = 3'b101; funct7_5 = 1; #1;
        if (alu_sel == 4'b0111) $display("PASS srai");
        else $display("FAIL srai: got %b", alu_sel);

        // the rest of funct3
        alu_op = 2'b10; funct7_5 = 0;
        funct3 = 3'b001; #1; if (alu_sel == 4'b0101) $display("PASS sll");  else $display("FAIL sll: got %b",  alu_sel);
        funct3 = 3'b010; #1; if (alu_sel == 4'b1000) $display("PASS slt");  else $display("FAIL slt: got %b",  alu_sel);
        funct3 = 3'b011; #1; if (alu_sel == 4'b1001) $display("PASS sltu"); else $display("FAIL sltu: got %b", alu_sel);
        funct3 = 3'b100; #1; if (alu_sel == 4'b0100) $display("PASS xor");  else $display("FAIL xor: got %b",  alu_sel);
        funct3 = 3'b110; #1; if (alu_sel == 4'b0011) $display("PASS or");   else $display("FAIL or: got %b",   alu_sel);
        funct3 = 3'b111; #1; if (alu_sel == 4'b0010) $display("PASS and");  else $display("FAIL and: got %b",  alu_sel);

        $finish;
    end
endmodule