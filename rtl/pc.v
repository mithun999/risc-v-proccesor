module pc(input clk,input reset,input taken,input [31:0]target,output reg [31:0]pc_out,output [31:0]pc_plus4);

 assign pc_plus4 = pc_out + 32'd4;// we increasing by byte

    always @(posedge clk) begin
        if (reset)
            pc_out <= 32'd0;
        else if (taken)
            pc_out <= target;
        else
            pc_out <= pc_plus4;
    end
endmodule


