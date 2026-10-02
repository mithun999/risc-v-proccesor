module regfile(input clk,we,input [4:0] rs1,
                input [4:0]rs2,input[4:0]rd,input[31:0]wd,output [31:0]rd1,output [31:0]rd2);
                reg [31:0] regs[31:0];
                integer i;
                initial begin
                    for(i=0;i<32;i++)
                    regs[i]=32'd0;
                end
                    // synchronous write, ignoring x0
    always @(posedge clk) begin
        if (we && (rd != 5'd0))
            regs[rd] <= wd;
    end

    // asynchronous (combinational) reads, x0 forced to 0
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
endmodule
            