module bridge_top(input hclk,hresetn,hwrite,hready_in,input [1:0]htrans, input [31:0]hwdata,haddr,prdata,output penable,pwrite,hready, output [2:0]psel, output [1:0]hres, output[31:0]paddr,pwdata,hrdata);

wire [31:0]hwdata1,hwdata2,haddr1,haddr2;
wire [2:0]temp_selx;

ahbslave
ahbslave_interface(hclk, hresetn, hwrite, hreadyin, hwdata, haddr, htrans, prdata, haddr1, haddr2, hwdata1, hwdata2, hwritereg, hwritereg1, hrdata, valid, temp_selx);

 apb_controller
fsm(hclk, hresetn, valid, hwrite, hwritereg, haddr, haddr1, haddr2, hwdata, hwdata1, prdata, temp_selx, pwrite, penable, psel, paddr, pwdata, hreadyout,hrdata);

endmodule


