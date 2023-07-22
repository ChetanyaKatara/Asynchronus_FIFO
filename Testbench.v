module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  wire [DATA_WIDTH-1:0] dataout;
  wire full;
  wire empty;
  reg [DATA_WIDTH-1:0] datain;
  reg w_en, wrclk, wrst;
  reg r_en, rclk, rrst;



  FIFO asf (w_en,r_en,wrclk,rclk,datain,dataout,wrst,rrst,full,empty);

  always #7 wrclk = ~wrclk;
  always #37 rclk = ~rclk;
  
  initial begin
    wrclk = 1'b0; wrst = 1'b0;
    w_en = 1'b0;
    datain = 0;
    
    repeat(10) @(posedge wrclk);
    wrst = 1'b1;

    repeat(2) begin
      for (integer i=0; i<30; i++) begin
        @(posedge wrclk) 
        if (!full) begin 
        w_en = (i%2 == 0)? 1'b1 : 1'b0; 
        datain = (w_en) ? $random: datain;end
       /* if (w_en) begin
          datain = $random;
        end */
      end
      end
  
    
  end

  initial begin
    rclk = 1'b0; rrst = 1'b0;
    r_en = 1'b0;

    repeat(20) @(posedge rclk);
    rrst = 1'b1;

    repeat(2) begin
      for (integer i=0; i<30; i++) begin
        @(posedge rclk) 
        if (!empty) begin
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
     end
      #50;
    end

    repeat(2) begin
      for (integer i=0; i<30; i++) begin
        @(posedge wrclk) 
        if (!full) begin 
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        datain = (w_en) ? $random: datain; end
        /* if (w_en) begin
          datain = $random;
        end */
      end
      end

      repeat(2) begin
      for (integer i=0; i<30; i++) begin
        @(posedge rclk) 
        if (!empty) begin
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
     end
      #50;
    end

   

    
  end
  
#8000 $finish;
end 
end
initial
begin
$dumpfile("dcfifo.vcd");
$dumpvars(0,asf);
end
endmodule
