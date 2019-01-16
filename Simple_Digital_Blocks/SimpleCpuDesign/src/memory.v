//=======================================================
// Module  : memory.v 
// Purpose : SRC code that represent a single port memory 
//           with size of 256 rows of 8-bit each 
//           
//=======================================================

module memory(
    input         clk,
    input         rd_wr,
    input         cs,
    input  [7:0]  addr, 
    input  [7:0]  wdata, 
    output [7:0]  rdata
);

reg [7:0] memBank [0:255];

//Read 
assign rdata = (cs && !rd_wr) ? memBank[addr] : 8'd0;

//Write 
always @ (posedge clk) 
    begin
        if(rd_wr && cs) 
            memBank[addr] <= wdata;
    end


endmodule
