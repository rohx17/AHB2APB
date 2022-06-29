module top_mod();
reg hclk, hrestn;
wire hwrite, hreadyin, hreadyout, penable, pwrite, penable_out, pwrite_out;
wire [31:0] haddr, hwdata, prdata, hrdata, paddr, pwdata, paddr_out, pwdata_out;
wire [1:0] htrans, hresp;
wire [2:0] psel, psel_out;

ahb_master_interface AHB_MASTER(hclk,hresten,hreadyout,hres,hrdata,hwrite,hreadyin,htrans,hwdata, haddr);
bridge_top BRIDGE_TOP( hclk,hresetn,hwrite,hready_in,htrans, hwdata,haddr,prdata, penable,pwrite,hready, psel, hres, paddr,pwdata,hrdata);
apb_interface APB_INTERFACE(  penable, pwrite, pselx, paddr, pwdata, prdata, penable_out, pwrite_out, pselx_out, paddr_out, pwdata_out);
 initial
begin
hclk = 1'b0;
forever
#10
hclk = ~ hclk;
end
task reset;
begin
@(negedge hclk);
hrestn = 1'b1;
@(negedge hclk);
hrestn = 1'b0;
end
endtask

initial

begin
reset;
AHB_MASTER.single_write();
//AHB_MASTER.single_read();
end
endmodule




