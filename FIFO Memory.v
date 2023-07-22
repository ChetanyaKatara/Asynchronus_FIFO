module (b_rptr,b_wrptr,full,empty,wrclk,rclk,datain,dataout,w_en,r_en);

input full,empty,w_en,r_en,wrclk,rclk;
input [Width:0]b_rptr,b_wrptr;
input [Datawidth-1:0]datain;
output [Datawidth-1:0]dataout;

reg [Datawidth-1:0] fifo[Depth-1:0]

always @ (posedge clk) begin
  if(w_en & !full) begin
    fifo[b_wrptr[Width-1:0]] <= datain[Datawidth-1:0];
  end
end

assign dataout[Datawidth-1:0] = fifo[b_rptr[Width-1:0]];
endmodule
