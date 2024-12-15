`timescale 1ps/1ps

module register_file_tb;

    localparam  NUM_REGISTERS = 8;
    localparam  DATA_WIDTH = 16;

    reg clk;
    reg reset;
    reg reg_write;

    reg  [3:0]               write_addr;
    reg  [DATA_WIDTH - 1: 0] write_data;
    reg  [3:0]               read_addr1;
    reg  [3:0]               read_addr2;

    wire [DATA_WIDTH - 1: 0] read_data1;
    wire [DATA_WIDTH - 1: 0] read_data2;

    register_file uut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    task validate_test (
        input [DATA_WIDTH - 1:0] expected_data1,
        input [DATA_WIDTH - 1:0] expected_data2
    );
    begin
        $display("read_data1 = %h, read_data2 = %h", read_data1, read_data2);
        $display("expected_1 = %h, expected_2 = %h", expected_data1, expected_data2);
        if (read_data1 !== expected_data1 | read_data2 !== expected_data2) begin
            $display("Test failed\n");
        end else begin
            $display("Test passed\n");
        end
    end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin : test_reg_file

        // in Verilog, declarrations must be at the beginning of the block
        integer i;
        reg [DATA_WIDTH-1:0] test_data [0:NUM_REGISTERS-1];

        // intialize signals
        reset = 0;
        reg_write = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;

        $display("Starting test...");

        $display("Test 1: reset clears the register file");
        reset = 1;
        #10;
        reset = 0;
        #10;
        read_addr1 = 0;
        read_addr2 = 1;
        #10;
        $display("reg 0 and 1 cleared?");
        validate_test({DATA_WIDTH{1'b0}}, {DATA_WIDTH{1'b0}});
        read_addr1 = 2;
        read_addr2 = 3;
        #10;
        $display("reg 2 and 3 cleared?");
        validate_test({DATA_WIDTH{1'b0}}, {DATA_WIDTH{1'b0}});
        read_addr1 = 4;
        read_addr2 = 5;
        #10;
        $display("reg 4 and 5 cleared?");
        validate_test({DATA_WIDTH{1'b0}}, {DATA_WIDTH{1'b0}});
        read_addr1 = 6;
        read_addr2 = 7;
        #10;
        $display("reg 6 and 7 cleared?");
        validate_test({DATA_WIDTH{1'b0}}, {DATA_WIDTH{1'b0}});

        
        // Initialize test data
        test_data[0] = 16'h1234;
        test_data[1] = 16'h5678;
        test_data[2] = 16'h9abc;
        test_data[3] = 16'hdef0;
        test_data[4] = 16'hfedc;
        test_data[5] = 16'hba98;
        test_data[6] = 16'h7654;
        test_data[7] = 16'h3210;

        $display("Test 2: Write to all registers");
        for (i = 0; i < NUM_REGISTERS; i = i + 2) begin
            $display("Write to register %0d and %0d", i, i+1);
            write_addr = i;
            write_data = test_data[i];
            reg_write = 1;
            #10;
            reg_write = 0;
            write_addr = i + 1;
            write_data = test_data[i+1];
            reg_write = 1;
            #10;
            read_addr1 = i;
            read_addr2 = (i + 1) % NUM_REGISTERS;
            #20;
            validate_test(test_data[i], (i == NUM_REGISTERS-1) ? {DATA_WIDTH{1'b0}} : test_data[i+1]);
        end

        // Test 3: mixing signals
        $display("Test 3: reg write = 0, write addr and write data != 0");
        write_addr = 0;
        write_data = 16'h1234;
        reg_write = 0;
        #10;
        read_addr1 = 0;
        read_addr2 = 1;
        #10;
        validate_test(16'h1234, 16'h5678);

        // end simulation
        $stop;
    end

endmodule