// tb/imm_gen_tb.v
module imm_gen_tb;
    reg  [31:0] inst;
    reg  [2:0]  imm_sel;
    wire [31:0] imm;

    imm_gen dut (.inst(inst), .imm_sel(imm_sel), .imm(imm));

    initial begin
        // I-type: addi x1, x0, -1   expect FFFFFFFF
        inst = 32'hFFF00093; imm_sel = 3'd0; #1;
        if (imm == 32'hFFFFFFFF) $display("PASS I-type");
        else  $display("FAIL I-type: got %h", imm);

        // S-type: sw x2, 8(x1)   expect 00000008
        inst = 32'h0020A423; imm_sel = 3'd1; #1;
        if (imm == 32'h00000008) $display("PASS S-type");
        else         $display("FAIL S-type: got %h", imm);

        // B-type: beq x1, x2, +8  -> expect 00000008
        inst = 32'h00208463; imm_sel = 3'd2; #1;
        if (imm == 32'h00000008) $display("PASS B-type");
        else                     $display("FAIL B-type: got %h", imm);

        // U-type: lui x5, 0x12345  -> expect 12345000
        inst = 32'h123452B7; imm_sel = 3'd3; #1;
        if (imm == 32'h12345000) $display("PASS U-type");
        else                     $display("FAIL U-type: got %h", imm);

        // J-type: jal x0, +8  -> expect 00000008
        inst = 32'h0080006F; imm_sel = 3'd4; #1;
        if (imm == 32'h00000008) $display("PASS J-type");
        else                     $display("FAIL J-type: got %h", imm);

        $finish;
    end
endmodule