`timescale 1ps/1ps

module sign_extender_tb;

    reg [15:0] input_signal;
    wire [31:0] output_signal;

    sign_extender uut (
        .input_data(input_signal),
        .output_data(output_signal)
    );

    task validate_test (
        input [31:0] expected_output
    );
    begin
        $display("output_signal = %h, expected_output = %h", output_signal, expected_output);
        if (output_signal !== expected_output) begin
            $display("Test failed\n");
        end else begin
            $display("Test passed\n");
        end
    end
    endtask

    initial begin

        $display("Test 1");
        input_signal = 16'h0000;
        #1;
        validate_test(32'h00000000);

        $display("Test 2");
        input_signal = 16'hFFFF;
        #1;
        validate_test(32'hFFFFFFFF);

        $display("Test 3");
        input_signal = 16'h8000;
        #1;
        validate_test(32'hFFFF8000);

        $display("Test 4");
        input_signal = 16'h7FFF;
        #1;
        validate_test(32'h00007FFF);

        $display("Test 5");
        input_signal = 16'h1234;
        #1;
        validate_test(32'h00001234);

        $stop;
    end

endmodule