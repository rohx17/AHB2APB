module apb_controller(hclk, hresetn, valid, hwrite, hwritereg, haddr, haddr1, haddr2, hwdata, hwdata1, prdata, temp_selx, pwrite, penable, psel, paddr, pwdata, hreadyout,hrdata);
input hclk, hresetn, valid, hwrite, hwritereg;
input [31:0]haddr, haddr1, haddr2, hwdata, hwdata1,prdata;
input [2:0] temp_selx;
output reg pwrite, penable, hreadyout;
output reg [31:0] paddr, pwdata , hrdata;
output reg [2:0] psel;
reg pwrite_temp, penable_temp, hreadyout_temp;
reg [31:0] paddr_temp, pwdata_temp;
reg [2:0] psel_temp;

parameter st_idle= 3'b000,
           st_read= 3'b001,
           st_renable= 3'b010,
           st_wwait= 3'b100,
            st_write= 3'b100,
            st_wenable= 3'b101,
            st_writep= 3'b110,
            st_wenablep= 3'b111;
reg [2:0] present, next;
always@(posedge hclk)
begin
if(hresetn)
present <= st_idle;
else
present <= next;
end
always@(*)
begin
next = st_idle;

case(present)

st_idle: begin
         if(valid == 1 && hwrite == 1)
         next = st_wwait;
          else if(valid==1 && hwrite==0)
          next = st_read;
         else
          next = st_idle;
         end
st_read: begin
  next = st_renable;
   end
st_renable: begin
  if(valid == 0)
next = st_idle;
else if(valid==1 && hwrite == 0)
next = st_read;
else if(valid==1 && hwrite == 1)
next = st_wwait;
end

st_wwait: begin
 if(valid == 1)
next = st_writep;
else if(valid==0)
next = st_write;

end
st_write: begin
if(valid == 0)
next = st_wenable;
else if(valid==1)
next = st_wenablep;
end
st_wenable: begin
if(valid == 0)
next = st_idle;
else if(valid == 1 && hwrite == 0)
next =  st_read;
else if(valid == 1 && hwrite ==1)
next = st_wwait;
end
st_writep: begin
    next = st_wenablep;
end
st_wenablep: begin
if(valid == 0 && hwritereg == 1)
next = st_write;
else if(valid==1 && hwritereg == 1)
next = st_writep;
else if(hwritereg == 0)
next = st_read;
end
endcase
end
// temp logic
always@(*)
begin
paddr_temp = 0;
pwrite_temp = 0;
psel_temp = 0;
penable_temp = 0;
hreadyout_temp = 0;
pwdata_temp = 0;
case(present)
st_idle: begin
if(valid==1 && hwrite==0)
begin
paddr_temp = haddr;
pwrite_temp = hwrite;
psel_temp <= temp_selx;
penable_temp =0;
hreadyout_temp =0;
end
else 
if(valid==1 && hwrite==1)
begin
psel_temp = 0;
penable_temp = 0;
hreadyout_temp = 1;
end
else
begin
psel_temp = 0;
penable_temp = 0;
hreadyout_temp = 1;
end
end
st_read: 
begin
penable_temp = 0;
hreadyout_temp = 0;
end
st_renable:
begin
paddr_temp = haddr;
hreadyout_temp = 1;
penable_temp = 1;
pwrite_temp = hwrite;
psel_temp = temp_selx;
end
st_wwait:
begin
paddr_temp = haddr1;
pwrite_temp = hwrite;
psel_temp = temp_selx;
penable_temp = 0;
hreadyout_temp = 1;
pwdata_temp = hwdata;
end
st_writep:
begin
penable_temp = 1;
hreadyout_temp = 1;
end
st_wenablep:
begin
hreadyout_temp = 1;
paddr_temp = haddr2;
penable_temp = 1;
pwrite_temp = 1;
psel_temp = temp_selx;
pwdata_temp = hwdata1;
end
st_write:
begin
penable_temp = 0;
hreadyout_temp = 1;
end
st_wenable:
begin
psel_temp = temp_selx;
penable_temp =1;
end
endcase
end

// output logic
always@(posedge hclk)
begin
if(hresetn)
begin
pwrite <= 0;
penable <= 0;
psel <= 0;
paddr <= 0;
pwdata <= 0;
hreadyout <= 1;
end
else
begin 
pwrite <= pwrite_temp;
penable <= penable_temp;
psel <= psel_temp;
paddr <= paddr_temp;
pwdata <= pwdata_temp;
hreadyout <= hreadyout_temp;
end
assign hrdata = prdata;
end

endmodule


