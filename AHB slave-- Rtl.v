

 module ahbslave(hclk, hresetn, hwrite, hreadyin, hwdata, haddr, htrans, prdata, haddr1, haddr2, hwdata1, hwdata2, hwritereg, hwritereg1, hrdata, valid, temp_selx);
 
  input hclk, hresetn, hreadyin, hwrite; 
input [31:0] haddr , hwdata, prdata ;
input [1:0]htrans;

   output reg [31:0]haddr1,haddr2, hwdata1, hwdata2;
output reg [31:0]hrdata;
 output reg valid,  hwritereg, hwritereg1;
   output reg [2:0]temp_selx;


  always @ (posedge hclk)
    begin
      if(!hresetn)
        begin
        haddr1<=0;
      haddr2<=0;
       hwdata1<=0;
      hwdata2<=0;
           hwritereg<=0;
           hwritereg1<=0;
       end
      else
        begin
          haddr1<=haddr;
          haddr2<=haddr1;
          hwdata1<=hwdata;
          hwdata2<=hwdata1;
          hwritereg<=hwrite;
          hwritereg1 <=hwritereg;
        end
end
always@(*)
    begin
      valid=1'b0;
if((haddr>=8'h8000_0000) && haddr< (8'h8C00_0000) && (htrans==2'b10 || htrans==2'b11) && (hreadyin==1)) 
valid=1'b1;
        else
        valid=1'b0;
    end
always@(*)
     begin
       temp_selx = 3'b000;
   if( (haddr>= 8'h8000_0000) && (haddr < 8'h8400_0000) )
     temp_selx = 3'b001;
   else
     if( (haddr>= 8'h8400_0000) && (haddr < 8'h8800_0000) )
       temp_selx = 3'b010;
   else
     if( (haddr>= 8'h8800_0000) && (haddr < 8'h8c00_0000) )
       temp_selx = 3'b100;
assign hrdata = prdata;
end

    endmodule
        
