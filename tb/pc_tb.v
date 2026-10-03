// tb/pc_tb.v
module pc_tb;
    reg         clk = 0;
    reg         reset, taken;
    reg  [31:0] target;
    wire [31:0] pc_out, pc_plus4;

    pc dut (.clk(clk), .reset(reset), .taken(taken), .target(target),
            .pc_out(pc_out), .pc_plus4(pc_plus4));

    always #5 clk = ~clk;

    initial begin
        reset = 1; taken = 0; target = 32'd0;

        // reset
        @(posedge clk); #1;
        if (pc_out == 32'd0) $display("PASS reset to 0");
        else                 $display("FAIL reset: got %h", pc_out);

        // count by 4: after 3 clocks the PC should be 12
        reset = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        if (pc_out == 32'd12) $display("PASS counts by 4");
        else                  $display("FAIL counts by 4: got %h", pc_out);
        if (pc_plus4 == 32'd16) $display("PASS pc_plus4");
        else                    $display("FAIL pc_plus4: got %h", pc_plus4);

        // taken branch: jump to 0x40
        taken = 1; target = 32'h00000040;
        @(posedge clk); #1;
        taken = 0;
        if (pc_out == 32'h40) $display("PASS taken jumps to target");
        else                  $display("FAIL taken: got %h", pc_out);

        // and it carries on from the new address
        @(posedge clk); #1;
        if (pc_out == 32'h44) $display("PASS continues from target");
        else                  $display("FAIL continues: got %h", pc_out);

        // reset again
        reset = 1;
        @(posedge clk); #1;
        if (pc_out == 32'd0) $display("PASS reset again");
        else                 $display("FAIL reset again: got %h", pc_out);

        $finish;
    end
endmodule