module Multiplier(mult_en, dataA, dataB, Q);
    input [127:0] dataA, dataB;
    input mult_en;
    output [255:0] Q;

    assign Q = (mult_en) ? dataA * dataB : 256'd0;

endmodule
