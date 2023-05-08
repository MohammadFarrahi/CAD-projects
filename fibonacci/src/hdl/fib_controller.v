module fib_controller (clk, rst, start, gt, stack_empty, c_code,
                        N_en, arg_en, arg_src, R_en, R_init, R_src,
                        d_src, c_src, comp_src, sub_src, push, pop, tos, finish);
    input clk, rst, start, gt, stack_empty;
    input [1:0] c_code;
    output reg N_en, arg_en, R_en, R_init, R_src, comp_src;
    output reg push, pop, tos, finish;
    output reg [1:0] arg_src, d_src, c_src, sub_src;

    reg [3:0] ns, ps;
    localparam [3:0] Idle = 0, Load = 1, Call = 2, Wait = 3, Recurv1 = 4,
                     Base = 5, Return = 6, Decide = 7, Mult1 = 8,
                     Recurv2 = 9, Poping = 10, Mult2 = 11;

    always @(posedge clk, posedge rst) begin
        if(rst)  ps <= Idle;
        else ps <= ns;
    end

    always @(ps) begin
        {N_en,arg_en,R_en,R_init,R_src,comp_src,arg_src,d_src,c_src,sub_src,push,pop,tos,finish} = 18'd0;
        
        case (ps)
            Idle: finish = 1'b1;
            Load: begin N_en = 1'b1; arg_en = 1'b1; arg_src = 2'b11; end
            Call: begin push = 1'b1; c_src = 2'b00; d_src = 2'b01; end
            Wait: comp_src = 0;
            Recurv1: begin push=1'b1; d_src=2'b00; c_src=2'b01; arg_en=1'b1; arg_src=2'b10; sub_src=2'b10; end
            Base: begin R_init = 1'b1; pop = 1'b1; end
            Return: pop = 1'b1;
            Mult1: begin comp_src=1'b1; sub_src=2'b00; R_src=1'b1; R_en=1'b1; end
            Recurv2: begin push=1'b1; c_src=2'b10; d_src=2'b10; arg_en=1'b1; sub_src=2'b11; arg_src=2'b10; end
            Poping: begin arg_en=1'b1; arg_src=2'b01; tos=1'b1; end
            Mult2: begin pop = 1'b1; R_en=1'b1; sub_src=2'b01; R_src=1'b0; comp_src=1'b1; end       endcase
    end

    always @(ps, start, gt, stack_empty) begin
        ns = Idle;
        case(ps)
            Idle: ns = start ? Load : Idle;
            Load: ns = Call;
            Call: ns = Wait;
            Wait: ns = gt ? Recurv1 : Base;
            Recurv1: ns = Call;
            Base: ns = Return;
            Return: ns = stack_empty ? Idle : Decide;
            Decide: ns = c_code == 2'b01 ? Mult1 : Poping; 
            Mult1: ns = Recurv2;
            Recurv2: ns = Call;
            Poping: ns = Mult2;
            Mult2: ns = Return;
            default: ns = Idle;
        endcase
    end
endmodule