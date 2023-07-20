module synchronizer(clk,rst,d_in,d_out);

parameter Datawidth = 8;
parameter Width = 3;
parameter Depth = 8;


  input clk,rst;
  input [Width:0]d_in;
  output reg [Width:0]d_out;
  reg [Width:0] q1;
  always@(posedge clk or negedge rst) begin
    if(!rst) begin
      q1 <= 0;
      d_out <= 0;
    end
    else begin
      q1 <= d_in;
      d_out <= q1;
    end
  end
endmodule