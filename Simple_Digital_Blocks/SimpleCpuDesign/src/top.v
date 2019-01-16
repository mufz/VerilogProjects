//=======================================================
// Module  : top.v 
// Purpose : Demonstrate a simple cpu pipeline example that 
//           performs following  
//           P0 : Flop the Inputs 
//           P1 : Read the register 
//           P2 : Perform ALU operation 
//           P3 : Write the register file
//           P4 : Write the memory 
// Naming  :
//          All wire ends with _w
//          All flops ends with _d
//=======================================================

module (
        input clk,
        input rst,
        input [31:0] rs1, 
        input [31:0] rs2, 
        input [32:0] rd, 
        input [4:0]  func, 
        input [32:0] addr
);

//P0
reg [31:0] rs1_p0_d;
reg [31:0] rs2_p0_d;
reg [4:0]  func_p0_d;
reg [32:0] addr_p0_d;
reg [32:0] rd_p0_d;

//P1
reg [31:0] a_p1_d;
reg [31:0] b_p1_d;
reg [4:0]  func_p1_d;
reg [32:0] addr_p1_d;
reg [32:0] rd_p1_d;

wire [31:0] rd1_p1_w;
wire [31:0] rd2_p1_w;

//P2
wire[31:0] z_w;
reg [31:0] z_p2;
reg [32:0] rd_p2;
reg [32:0] addr_p2;

//P3 
wire [31:0] ws_p3_w;
wire [31:0] wd_p3_w;
wire wvalid_p3_w;

//P4
wire [31:0] addr_p4_w;
wire [31:0] z_p4_w;
wire cs_flag_w;
wire rd_wr_flag_w;

//=======================================================
// Module Instance for registers,memory and alu 
//  
//=======================================================
registerFile uRegFile(
    .clk(clk),
    .rs1(rs1_p0_w),
    .rs2(rs2_p0_w),
    .wd(wd_p3_w),
    .ws(ws_p3_w),
    .wvalid(wvalid_p3_w),
    .rd1(rd1_p1_w),
    .rd2(rd2_p1_w)
);


alu uAlu(
     .a(a_p2_w),
     .b(b_p2_w),
     .func(func_p2_w), 
     .z(z_w)
);


memory uMem(
    .clk(clk),
    .rd_wr(rd_wr_flag_w),
    .cs(cs_flag_w),
    .addr(addr_p4_w), 
    .wdata(z_p4_w), 
    .rdata()
);


//=======================================================
// Pipeline Stage-0
// 
//=======================================================
assign rs1_p0_w = rs1_p0_d;
assign rs2_p0_w = rs2_p0_d;
always @ (posedge clk or negedge rst)
begin
    if(!rst) begin
        rs1_p0_d  <= 32'd0;
        rs2_p0_d  <= 32'd0;
        func_p0_d <= 4'd0;
        addr_p0_d <= 33'd0;
        rd_p0_d   <= 33'd0;
    end else begin
        rs1_p0_d  <= rs1;
        rs2_p0_d  <= rs2;
        func_p0_d <= func;
        addr_p0_d <= addr;
        rd_p0_d   <= rd;
    end
end

//=======================================================
// Pipeline Stage-1
// Read the Register 
//=======================================================
always @ (posedge clk or negedge rst)
begin
    if(!rst) begin
        a_p1_d    <= 32'd0;
        b_p1_d    <= 32'd0;
        func_p1_d <= 4'd0;
        addr_p1_d <= 33'd0;
        rd_p1_d   <= 33'd0;
    end else begin
        a_p1_d    <= rd1_p1_w;
        b_p1_d    <= rd2_p2_w;
        func_p1_d <= func_p0_d;
        addr_p1_d <= addr_p0_d;
        rd_p1_d   <= rd_p0_d;
    end
end

//=======================================================
// Pipeline Stage-2
// Perform ALU  operation 
//=======================================================
assign a1_p2_w   = a1_p1_d;
assign a2_p2_w   = a2_p1_d;
assign func_p2_w = func_p1_d;

always @ (posedge clk or negedge rst)
begin
    if(!rst) begin
        z_p2_d    <= 32'd0;
        addr_p2_d <= 33'd0;
        rd_p2_d   <= 33'd0;
    end else begin
        z_p2_d    <= z_w; 
        addr_p2_d <= addr_p1_d;
        rd_p2_d   <= rd_p1_d;
    end
end

//=======================================================
// Pipeline Stage-3
// Write to destination register if valid 
//=======================================================
assign wvalid_p3_w = rd_p2_d[32] ? 1'b1 : 1'b0;
assign ws_p3_w  = wvalid_p3_w ? rd_p2_d[31:0] : 32'd0;
assign wd_p3_w  = wvalid_p3_w ? z_p2_d        : 32'd0;

always @ (posedge clk or negedge rst)
begin
    if(!rst) begin
        z_p3_d    <= 32'd0;
        addr_p3_d <= 33'd0;
    end else begin
        z_p3_d    <= z_p2_d; 
        addr_p3_d <= addr_p2_d;
    end
end

//=======================================================
// Pipeline Stage-4
// Write to memory if valid 
//=======================================================
assign rd_wr_flag_w = addr_p3_d[32] ? 1'b1 : 1'b0;
assign addr_p4_w    = rd_wr_flag_w  ? addr_p3_d[31:0] : 32'd0;  
assign z3_p4_w      = rd_wr_flag_w  ? z_p3_d          : 32'd0; 


endmodule
