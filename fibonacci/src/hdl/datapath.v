module fib_datapath(clk, rst, N, N_en, arg_en, arg_src, R_en, R_init,
                    R_src, d_src, c_src, comp_src, sub_src, push, pop, tos,
                    gt, stack_empty, c_code, result);
    input clk, rst;
    input [127:0] N;
    input N_en, arg_en, R_en, R_init, R_src, comp_src;
    input push, pop, tos;
    input [1:0] arg_src, d_src, c_src, sub_src;

    output gt, stack_empty;
    output [1:0] c_code;
    output [127:0] result;
    
    wire [127:0] Return_out;
    wire [127:0] N_out;
    wire [127:0] Return_in;
    wire [127:0] arg_in;
    wire [127:0] arg_out;
    wire [127:0] rsh_out;
    wire [127:0] add_out;
    wire [127:0] sub_out;
    wire [127:0] sub_in;
    wire [127:0] d_in;
    wire [127:0] d_out;
    wire [127:0] new_d_out;
    wire [127:0] comp_in_B;
    wire [127:0] d_mux_out;
    wire [255:0] mult_out;
    wire [127:0] mux1_out, mux2_out;
    wire [1:0] c_code_in;

    Register_ #(128) N_reg(clk, rst, N_en, 1'b0, N, N_out);
    Register_ #(128) Return_reg(clk, rst, R_en, R_init, Return_in, Return_out);
    Register_ #(128) arg_reg(clk, rst, arg_en, 1'b0, arg_in, arg_out);

    Stack stack(clk, rst, pop, push, tos, d_in, d_out, stack_empty);

    Rshifter #(1, 128) Right_Shifter(N_out, rsh_out);

    CombAddSub_ adder(1'b1, 1'b0, arg_out, mult_out[127:0], add_out);
    CombAddSub_ subtracter(1'b0, 1'b1, new_d_out, sub_in, sub_out);

    Multiplier multiplier(1'b1, sub_out, Return_out, mult_out);

    Comparator comparator(new_d_out, comp_in_B, gt);

    Mux_2to1 #(128) mux1(gt, 128'd2, 128'd1,  mux1_out);
    Mux_2to1 #(128) mux2(gt, 128'd1, 128'd2,  mux2_out);
    Mux_2to1 #(128) mux_return(R_src, add_out, mult_out[127:0],  Return_in);
    Mux_2to1 #(128) mux_comp(comp_src, 128'd1, rsh_out,  comp_in_B);
    Mux_3to1 #(2) mux_c(c_src, 2'b0, 2'b01, 2'b10, c_code_in);
    Mux_3to1 #(128) mux_d(d_src, new_d_out, arg_out, Return_out, d_mux_out);
    Mux_4to1 #(128) mux_arg(arg_src, N_out, new_d_out, sub_out, N, arg_in);
    Mux_4to1 #(128) mux_sub(sub_src, mux1_out, mux2_out, 128'd1, 128'd2, sub_in);

    assign c_code = d_out[127:126];
    assign new_d_out = {2'b00, d_out[125:0]};
    assign d_in = {c_code_in, d_mux_out[125:0]};
    assign result = Return_out;
endmodule