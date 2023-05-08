module Comparator(dataA, dataB, gt);
    input [127:0] dataA, dataB;
    output gt;

    assign gt = (dataA > dataB) ? 1 : 0;

endmodule
