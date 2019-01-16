//=======================================================
// Module  : registerFile.v 
// Purpose : Source code for 16x16 register bank 
//           This code represent 2 read port and 1 write 
//           port register file
//=======================================================

module registerFile(
    input         clk,
    input  [3:0]  rs1,
    input  [3:0]  rs2,
    input  [15:0] wd,
    input  [3:0]  ws,
    input         wvalid,
    output [15:0] rd1,
    output [15:0] rd2
);

reg [15:0] regBank [0:15];

//Read 
assign rd1 = regBank[rs1];
assign rd2 = regBank[rs2];

//Write 
always @ (posedge clk) 
    begin
        if(wvalid) 
            regBank[ws] <= wd;
    end


endmodule
