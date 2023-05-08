module Rshifter #(parameter num_of_shifts = 2, input_len = 32) (in, out);
input [input_len - 1 : 0] in;
output [input_len - 1 : 0] out;
assign out = in >> num_of_shifts;
endmodule
