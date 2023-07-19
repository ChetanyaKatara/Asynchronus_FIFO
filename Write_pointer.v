module (wrclk,wrst,g_rptr_sync,b_wrptr,g_wptr,full,w_en);
input wrclk,wrst,w_en;
input [Width:0]g_rptr_sync;
output full;
output reg [Width:0]b_wrptr,g_wptr;

assign wire b_wrptr_next = b_wrptr + (w_en & !full);
assign wire g_wptr_next = (b_wrptr_next >> 1) ^ b_wrptr_next;
assign wire wfull <= (g_wptr_next == {~g_rptr_sync[Width:Width-1],g_rptr_sync[Width-2:0]})

always @ (posedge wrclk or negedge wrst) begin
  if (!wrst) begin
    b_wrptr <= 0;
    g_wptr <= 0;
    full <= 0;
  end
  else begin
    b_wrptr <= b_wrptr_next;
    g_wptr <= g_wptr_next;
    full <= wfull;
  end;
end

endmodule