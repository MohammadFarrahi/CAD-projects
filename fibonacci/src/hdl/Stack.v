module Stack(clk, rst, pop, push, tos, d_in, d_out, empty);
    input clk, rst, pop, push, tos;
    input [127:0] d_in;
    output reg [127:0] d_out;
    output reg empty;

    reg [127:0] mem [0:(2**16)-1];
    reg [15:0] top_of_stack;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            d_out <= 128'd0;
            top_of_stack <= 16'd0;
            mem[16'd0] <= 128'd0;
        end
        else if(pop) begin
            d_out <= mem[top_of_stack];
            if(~empty) top_of_stack <= top_of_stack - 16'd1;
        end
        else if(push) begin
            mem[top_of_stack + 16'b1] <= d_in;
            d_out <= d_in;
            top_of_stack <= top_of_stack + 16'd1;
        end
        else if(tos) d_out <= mem[top_of_stack];
        else d_out <= d_out;
    end
    always @(top_of_stack) begin
        empty = ~(|top_of_stack) ? 1'b1 : 1'b0;
    end
endmodule
