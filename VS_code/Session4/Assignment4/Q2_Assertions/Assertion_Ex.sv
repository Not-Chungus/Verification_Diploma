module Examples_SVA();

//1.
assert property (@(posedge clk) a |-> ##2 b);

//2.
assert property (@(posedge clk) (a&b) |-> ##[1:3] c);

//3.
sequence s11b;
    req ##2 gnt;
endsequence
assert property (@(posedge clk) s11b |-> ##2 (!b));

//4.1
property p_decoder;
    (@(posedge clk) $onehot(Y));
endproperty
assert_decoder: assert property (p_decoder);
//4.2
property p_encoder;
    (@(posedge clk) ~(|D) |-> !valid);
endproperty
assert_encoder: assert property (p_encoder);

endmodule
