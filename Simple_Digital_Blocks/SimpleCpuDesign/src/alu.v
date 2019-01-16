module alu(
    input [31:0] a,
    input [31:0] b,
    input [4:0]  func, 
    output [31:0] z
);

parameter ADD  = 4'd1; 
parameter SUB  = 4'd2;
parameter MUL  = 4'd3;
parameter SELA = 4'd4;
parameter SELB = 4'd5;
parameter AND  = 4'd6;
parameter OR   = 4'd7;
parameter XOR  = 4'd8;
parameter NEGA = 4'd9;
parameter NEGB = 4'd10;
parameter SRA  = 4'd11;
parameter SLA  = 4'd12;

always @ (*) 
begin 
    case(func) 
        begin
            ADD  : z = a + b;
            SUB  : z = a - b;
            MUL  : z = a * b;
            SELA : z = a;
            SELB : z = b;
            AND  : z = a & b;
            OR   : z = a | b;
            XOR  : z = a ^ b;
            NEGA : z = ~a;
            NEGB : z = ~b;
            SRA  : z = a >> 1;
            SLA  : z = a << 1;
        end 
end

endmodule 
