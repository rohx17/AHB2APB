module apb_interface( input penable, pwrite, input [2:0] pselx, input [31:0] paddr, pwdata, output reg [31:0] prdata, output penable_out, pwrite_out, output [2:0] pselx_out, 
output [31:0] paddr_out, pwdata_out);
 assign penable_out = penable;
assign pwrite_out = pwrite;
assign pslex_out = pselx;
assign paddr_out = paddr;
assign pwdata_out = pwdata;

always@(*)
begin
if(!pwrite && penable)
prdata = ($random) % 256;
else
prdata = 32'd0;
end
endmodule

