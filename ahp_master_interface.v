module ahb_master_interface(input hclk,hresten,hreadyout,input [1:0]hres,input [31:0]hrdata, output reg hwrite,hreadyin, output reg[1:0]htrans, output reg[31:0]hwdata, haddr);

reg [2:0]hsize;
reg [2:0]hburst;
integer i=0;
task single_write;
begin
@(posedge hclk)
#1
begin
hwrite=1;
hreadyin=1; //master is able to take new transaction
hburst=3'b000; //transfering 8 bit of data(byte transfer)
htrans=2'd2; //non seq transfer
haddr=32'h8000_0001; //address
end
@(posedge hclk)
#1
begin
htrans=2'd0; //ideal(no transction)
hwdata=32'h00001122;
end
end
endtask

task single_read();
begin
@(posedge hclk)
#1
begin
hwrite=0;
hreadyin=1; //master is able to take new transaction
htrans=2'd2; //non seq transfer
haddr=32'h8000_0001; //address
end
@(posedge hclk)
#1
begin
htrans=2'd0; //ideal(no transction)
end
end

endtask
endmodule

