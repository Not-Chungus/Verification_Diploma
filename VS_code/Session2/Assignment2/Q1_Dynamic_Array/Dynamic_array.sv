module testing_dynamic_arrays;

    initial begin

    int dyn_arr1[];
    int static_initialization[6] = '{9,1,8,3,4,4}; 
    int dyn_arr2[];
    dyn_arr2 = new[6](static_initialization);

    dyn_arr1 = new[6];

    foreach (dyn_arr1[i]) begin
        dyn_arr1[i] = i;
    end

    $display("dyn_arr1 elements: %p  | Size = %d", dyn_arr1, $size(dyn_arr1));

    dyn_arr1.delete();

    dyn_arr2.reverse();
    $display("dyn_arr2 elements reversed: %p", dyn_arr2);

    dyn_arr2.sort();
    $display("dyn_arr2 elements sorted: %p", dyn_arr2);

    dyn_arr2.rsort();
    $display("dyn_arr2 elements reverse sorted: %p", dyn_arr2);

    dyn_arr2.shuffle();
    $display("dyn_arr2 elements shuffled: %p", dyn_arr2);

    

    end




endmodule