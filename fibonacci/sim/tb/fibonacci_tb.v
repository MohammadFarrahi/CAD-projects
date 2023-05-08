`timescale 1ns/1ns
module fibonacci_tb();
    reg clk = 0, rst = 0, start = 0;
    wire [127:0] result;
    wire finish;
    
    localparam NUM_OF_TESTS = 4;
    localparam MAX_BIT_ANSWER = 12;
    reg [MAX_BIT_ANSWER+4:0] test_vectors [0:NUM_OF_TESTS-1];
    integer index = 0;
    initial $readmemb("./file/test_vectors.txt", test_vectors);

    always #10 clk = ~clk;
    fibonacci uut(clk, rst, start, test_vectors[index][4:0], finish, result);

    always @(finish) begin
        if($time > 60 && finish == 1'b1) begin
            $display("input: %d | output: %d | expected: %d\n", test_vectors[index][4:0], result, test_vectors[index][MAX_BIT_ANSWER+4:5]);
            if (result == test_vectors[index][MAX_BIT_ANSWER+4:5]) $display("valid output\n");
            else $display("invalid output\n");
            if(index < NUM_OF_TESTS - 1) begin
                index = index + 1;
                #40 start = 1;
                #20 start = 0;
            end
            else $finish;
        end
    end
    initial begin
        // reseting module and first start
        #5 rst = 1;
        #20 rst = 0;
        start = 1;
        #20 start = 0;
    end
endmodule