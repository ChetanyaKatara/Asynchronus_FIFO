module (rclk,r_en,g_wptr_sync,b_rptr,g_rptr,rrst,empty);
input rclk,r_en,rrst;
output reg [Width:0]b_rptr,g_rptr;
output empty;
input [Width:0]g_wptr_sync;

assign wire b_rptr_next = b_rptr + (r_en + !empty);
assign wire g_rptr_next = ((g_rptr_next >> 1) ^ g_rptr_next);
assign wire rempty = (g_rptr_next == g_wptr_sync);

always @ (posedge clk or negedge rrst) begin
  if (!rrst) begin
    b_rptr <= 0;
    g_rptr <= 0;
    rempty <= 0;
  end
  else begin
    b_rptr <= b_rptr_next;
    g_rptr <= g_rptr_next;
    empty <= rempty;
  end
end

endmodule