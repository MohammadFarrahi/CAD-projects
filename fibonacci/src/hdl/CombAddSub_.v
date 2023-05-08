module CombAddSub_(add_en, sub_en, dataA, dataB, Q);
    input [127:0] dataA, dataB;
    input add_en, sub_en;
    output [127:0] Q;

    assign Q = (add_en) ? dataA + dataB : (sub_en) ? dataA - dataB : dataA;

endmodule
