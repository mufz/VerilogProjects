//=======================================================
// Module  : pipeline.v 
// Purpose : Demonstrate a simple pipeline example that 
//           performs following  
//           P1 : x1 = a + b x2 = c - d
//           P2 : x3 = x1 + x2 
//           P3 : e = x3 * d
//=======================================================

module pipeline(
    input  clk,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,
    input  [31:0] d,
    output [31:0] e
);

reg [31:0] x1_p1;
reg [31:0] x2_p1; 
reg [31:0] d_p1;
reg [31:0] x3_p2;
reg [31:0] d_p2; 
reg [31:0] f;

assign e = f;

//=======================================================
// Pipeline Stage-1
//=======================================================
always @ (posedge clk) 
begin
    x1_p1 <= (a + b);
    x2_p1 <= (c-d);
    d_p1  <= d;
end

//=======================================================
// Pipeline Stage-2
//=======================================================

always @ (posedge clk) 
begin
    x3_p2 <= (x1_p1 + x2_p1);
    d_p2  <= d_p1;
end

//=======================================================
// Pipeline Stage-3
// Output should be floped as per design gudielines.
//=======================================================

always @ (posedge clk) 
begin
    f <= (x3_p2 * d_p2);
end

endmodule
