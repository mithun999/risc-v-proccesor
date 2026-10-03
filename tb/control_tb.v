// tb/control_tb.v
module control_tb;
    reg  [6:0] opcode;
    wire       reg_write, b_sel, mem_read, mem_write, branch, jump, jalr;
    wire [2:0] imm_sel;
    wire [1:0] a_sel, alu_op, wb_sel;

    wire [15:0] bus = {reg_write, imm_sel, a_sel, b_sel, alu_op,
                       mem_read, mem_write, wb_sel, branch, jump, jalr};

    control dut (.opcode(opcode), .reg_write(reg_write), .imm_sel(imm_sel),
                 .a_sel(a_sel), .b_sel(b_sel), .alu_op(alu_op),
                 .mem_read(mem_read), .mem_write(mem_write), .wb_sel(wb_sel),
                 .branch(branch), .jump(jump), .jalr(jalr));

    initial begin
        // R-type (add)
        opcode = 7'b0110011; #1;
        if (bus === 16'b1_000_00_0_10_0_0_00_0_0_0) $display("PASS R-type");
        else $display("FAIL R-type: got %b", bus);

        // I-type (addi)
        opcode = 7'b0010011; #1;
        if (bus === 16'b1_000_00_1_11_0_0_00_0_0_0) $display("PASS I-type");
        else $display("FAIL I-type: got %b", bus);

        // Load (lw)
        opcode = 7'b0000011; #1;
        if (bus === 16'b1_000_00_1_00_1_0_01_0_0_0) $display("PASS load");
        else $display("FAIL load: got %b", bus);

        // Store (sw)
        opcode = 7'b0100011; #1;
        if (bus === 16'b0_001_00_1_00_0_1_00_0_0_0) $display("PASS store");
        else $display("FAIL store: got %b", bus);

        // Branch (beq)
        opcode = 7'b1100011; #1;
        if (bus === 16'b0_010_00_0_01_0_0_00_1_0_0) $display("PASS branch");
        else $display("FAIL branch: got %b", bus);

        // jal
        opcode = 7'b1101111; #1;
        if (bus === 16'b1_100_00_0_00_0_0_10_0_1_0) $display("PASS jal");
        else $display("FAIL jal: got %b", bus);

        // jalr
        opcode = 7'b1100111; #1;
        if (bus === 16'b1_000_00_1_00_0_0_10_0_1_1) $display("PASS jalr");
        else $display("FAIL jalr: got %b", bus);

        // lui
        opcode = 7'b0110111; #1;
        if (bus === 16'b1_011_10_1_00_0_0_00_0_0_0) $display("PASS lui");
        else $display("FAIL lui: got %b", bus);

        // auipc
        opcode = 7'b0010111; #1;
        if (bus === 16'b1_011_01_1_00_0_0_00_0_0_0) $display("PASS auipc");
        else $display("FAIL auipc: got %b", bus);

        // unknown opcode -> everything off
        opcode = 7'b1111111; #1;
        if (bus === 16'b0) $display("PASS unknown opcode");
        else $display("FAIL unknown opcode: got %b", bus);

        $finish;
    end
endmodule