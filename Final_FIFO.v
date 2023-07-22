module FIFO(w_en,r_en,wrclk,rclk,datain,dataout,wrst,rrst,full,empty);

parameter Datawidth = 8;
parameter Width = 3;
parameter Depth = 8;


input w_en,r_en,wrclk,rrst,rclk,wrst;
input [Datawidth-1:0]datain;
output [Datawidth-1:0]dataout;
output empty,full;

wire [Width:0]b_rptr,b_wptr,g_rptr,g_wptr;
wire [Width:0]g_rptr_sync,g_wptr_sync;

synchronizer wdsync(.clk(rclk),
                    .rst(rrst),
                    .d_in(g_wptr),
                    .d_out(g_wptr_sync));


synchronizer rdsync(.clk(wrclk),
                    .rst(wrst),
                    .d_in(g_rptr),
                    .d_out(g_rptr_sync));

wrptr write_mod (.wrclk(wrclk),
                .wrst(wrst),
                .g_wptr(g_wptr),
                .b_wptr(b_wptr),
                .full(full),
                .w_en(w_en),
                .g_rptr_sync(g_rptr_sync));

rrptr read_mod (.rclk(rclk),
                .rrst(rrst),
                .g_rptr(g_rptr),
                .b_rptr(b_rptr),
                .empty(empty),
                .r_en(r_en),
                .g_wptr_sync(g_wptr_sync));


memory mem(.w_en(w_en),
           .r_en(r_en),
           .wrclk(wrclk),
           .rclk(rclk),
           .b_rptr(b_rptr),
           .b_wptr(b_wptr),
           .empty(empty),
           .full(full),
           .datain(datain),
           .dataout(dataout));

endmodule

module wrptr(wrclk,wrst,g_rptr_sync,b_wptr,g_wptr,full,w_en);

parameter Datawidth = 8;
parameter Width = 3;
parameter Depth = 8;


input wrclk,wrst,w_en;
input [Width:0]g_rptr_sync;
output reg full;
output reg [Width:0]b_wptr,g_wptr;
wire [Width:0]b_wptr_next,g_wptr_next;
wire wfull;


assign b_wptr_next = b_wptr + (w_en & !full);
assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;
assign wfull = (g_wptr_next == {~g_rptr_sync[Width:Width-1], g_rptr_sync[Width-2:0]});

always @ (posedge wrclk or negedge wrst) begin
  if (!wrst) begin
    b_wptr <= 0;
    g_wptr <= 0;
    full <= 0;
  end
  else begin
    b_wptr <= b_wptr_next;
    g_wptr <= g_wptr_next;
    full <= wfull;
  end;
end

endmodule

module rrptr(rclk,r_en,g_wptr_sync,b_rptr,g_rptr,rrst,empty);

parameter Datawidth = 8;
parameter Width = 3;
parameter Depth = 8;


input rclk,r_en,rrst;
output reg [Width:0]b_rptr,g_rptr;
output reg empty;
input [Width:0]g_wptr_sync;
wire [Width:0]b_rptr_next,g_rptr_next;
wire rempty;

assign rempty = (g_rptr_next == g_wptr_sync);
assign b_rptr_next = b_rptr + (r_en & !empty);
assign g_rptr_next = ((b_rptr_next >> 1) ^ b_rptr_next);


always @ (posedge rclk or negedge rrst) begin
  if (!rrst) begin
    b_rptr <= 0;
    g_rptr <= 0;
    empty <= 1;
  end
  else begin
    b_rptr <= b_rptr_next;
    g_rptr <= g_rptr_next;
    empty <= rempty;
  end
end

endmodule

module memory(b_rptr,b_wptr,full,empty,wrclk,rclk,datain,dataout,w_en,r_en);


parameter Datawidth = 8;
parameter Width = 3;
parameter Depth = 8;


input full,empty,w_en,r_en,wrclk,rclk;
input [Width:0]b_rptr,b_wptr;
input [Datawidth-1:0]datain;
output [Datawidth-1:0]dataout;

reg [Datawidth-1:0] fifo[Depth-1:0];

always @ (posedge wrclk) begin
  if(w_en & !full) begin
    fifo[b_wptr[Width-1:0]] <= datain[Datawidth-1:0];
  end
end

assign dataout[Datawidth-1:0] = fifo[b_rptr[Width-1:0]];
endmodule


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
