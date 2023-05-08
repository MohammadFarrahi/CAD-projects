module fibonacci(clk, rst, start, N, finish, result);
    input clk, rst, start;
    input [4:0] N;
    output [127:0] result;
    output finish;

    wire gt, stack_empty, N_en, arg_en, R_en, R_init, R_src, comp_src;
    wire push, pop, tos;
    wire [1:0] arg_src, d_src, c_src, sub_src, c_code;

    fib_controller controller(clk, rst, start, gt, stack_empty, c_code,
                    N_en, arg_en, arg_src, R_en, R_init, R_src,
                    d_src, c_src, comp_src, sub_src, push, pop, tos, finish);

    fib_datapath datapath(clk, rst, {123'd0, N}, N_en, arg_en, arg_src, R_en, R_init,
                    R_src, d_src, c_src, comp_src, sub_src, push, pop, tos,
                    gt, stack_empty, c_code, result);
endmodule
