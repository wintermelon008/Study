

module timer (
    input clk,
    input rstn,
    input butc,      // when 1, then timer clear
    output [7:0] an,    // Connecting segments display
    output [6:0] seg,    // Connecting segments display

    input stop
);

reg [3:0] sec1, sec2, sec3, min;
reg [31:0] timeupdate;

wire db_butc;
wire timer_rst;
reg [31:0] disp_data;
wire pulse;
assign timer_rst = rstn && ~db_butc; // when 0 then reset 
assign pulse = (timeupdate == 32'd9999999) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (timeupdate >= 32'd10000000) 
        timeupdate <= 0;
    else
        timeupdate <= timeupdate + 1;
end 


always@(posedge clk) begin
    if(~timer_rst)
        sec3<=4'b0;
    else if(pulse==0)
        sec3<=sec3;
    else if(sec3==4'b1001)
        sec3<=4'b0;
    else
        sec3<=sec3+1'b1;
end

always@(posedge clk) begin
    if(~timer_rst)
        sec2<=4'b0;
    else if(pulse==0)
        sec2<=sec2;
    else if(sec3!=4'b1001)
        sec2<=sec2;
    else if(sec2==4'b1001)
        sec2<=4'b0;
    else
        sec2<=sec2+1'b1;
end

always@(posedge clk) begin
    if(~timer_rst)
        sec1<=4'b0;
    else if(pulse==0)
        sec1<=sec1;
    else if(sec3!=4'b1001)
        sec1<=sec1;
    else if(sec2!=4'b1001)
        sec1<=sec1;
    else if(sec1==4'b0101)
        sec1<=4'b0;
    else
        sec1<=sec1+1'b1;
end

always@(posedge clk) begin
    if(~timer_rst)
        min<=4'b0;
    else if(pulse==0)
        min<=min;
    else if(sec3!=4'b1001)
        min<=min;
    else if(sec2!=4'b1001)
        min<=min;
    else if(sec1!=4'b0101)
        min<=min;
    else if(min==4'b1001)
        min<=4'b0;
    else
        min<=min+1'b1;
end

always @(posedge clk) begin
    if (~stop) begin
        disp_data <= {{12'b0}, {min}, {8'b0}, {sec1}, {sec2}};
    end
end


SEG_OUT seg_1(
    .clk(clk),
    .rstn(rstn),
    .data(disp_data),      // The data ready to output
    .an(an),    // Connecting segments display
    .seg(seg)    // Connecting segments display
);

Debouncer db_butc_timer(
    .ori_but(butc),
    .rstn(rstn),
    .clk(clk),
    .deb_but(db_butc)
);
endmodule