// rtl/control.v
module control (
    input  [6:0] opcode,
    output reg       reg_write,
    output reg [2:0] imm_sel,
    output reg [1:0] a_sel,
    output reg       b_sel,
    output reg [1:0] alu_op,
    output reg       mem_read,
    output reg       mem_write,
    output reg [1:0] wb_sel,
    output reg       branch,
    output reg       jump,
    output reg       jalr
);
    localparam OP_LUI    = 7'b0110111,
               OP_AUIPC  = 7'b0010111,
               OP_JAL    = 7'b1101111,
               OP_JALR   = 7'b1100111,
               OP_BRANCH = 7'b1100011,
               OP_LOAD   = 7'b0000011,
               OP_STORE  = 7'b0100011,
               OP_IMM    = 7'b0010011,
               OP_REG    = 7'b0110011;

    always @(*) begin
        // defaults: a harmless "do nothing" instruction
        reg_write = 0;
        imm_sel   = 3'd0;
        a_sel     = 2'd0;
        b_sel     = 0;
        alu_op    = 2'b00;
        mem_read  = 0;
        mem_write = 0;
        wb_sel    = 2'd0;
        branch    = 0;
        jump      = 0;
        jalr      = 0;

        case (opcode)
            OP_REG:    begin reg_write = 1; alu_op = 2'b10; end
            OP_IMM:    begin reg_write = 1; b_sel = 1; alu_op = 2'b11; end
            OP_LOAD:   begin reg_write = 1; b_sel = 1; mem_read = 1; wb_sel = 2'd1; end
            OP_STORE:  begin imm_sel = 3'd1; b_sel = 1; mem_write = 1; end
            OP_BRANCH: begin imm_sel = 3'd2; branch = 1; alu_op = 2'b01; end
            OP_JAL:    begin reg_write = 1; imm_sel = 3'd4; jump = 1; wb_sel = 2'd2; end
            OP_JALR:   begin reg_write = 1; b_sel = 1; jump = 1; jalr = 1; wb_sel = 2'd2; end
            OP_LUI:    begin reg_write = 1; imm_sel = 3'd3; a_sel = 2'd2; b_sel = 1; end
            OP_AUIPC:  begin reg_write = 1; imm_sel = 3'd3; a_sel = 2'd1; b_sel = 1; end
            default: ;
        endcase
    end
endmodule