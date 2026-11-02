module washing_machine_tb;

    logic clk, rst;
    logic start, door_closed;
    logic water_full, wash_done;
    logic tub_empty, rinse_done, spin_done;

    logic inlet_valve, wash_motor;
    logic drain_pump, spin_motor, done;

    // DUT Instantiation
    washing_machine uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .door_closed(door_closed),
        .water_full(water_full),
        .wash_done(wash_done),
        .tub_empty(tub_empty),
        .rinse_done(rinse_done),
        .spin_done(spin_done),
        .inlet_valve(inlet_valve),
        .wash_motor(wash_motor),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor),
        .done(done)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Stimulus
    initial begin

        $monitor("Time=%0t | State=%s | Valve=%b | Wash=%b | Drain=%b | Spin=%b | Done=%b",
                 $time, uut.current_state.name(),
                 inlet_valve, wash_motor, drain_pump,
                 spin_motor, done);

        // Initialize inputs
        rst = 1;
        start = 0;
        door_closed = 0;
        water_full = 0;
        wash_done = 0;
        tub_empty = 0;
        rinse_done = 0;
        spin_done = 0;

        #10;
        rst = 0;

        // Start washing cycle
        #10;
        door_closed = 1;
        start = 1;

        #10;
        start = 0;

        // Fill water
        #10;
        water_full = 1;

        #10;
        water_full = 0;

        // Washing
        #10;
        wash_done = 1;

        #10;
        wash_done = 0;

        // Drain water
        #10;
        tub_empty = 1;

        #10;
        tub_empty = 0;

        // Rinse
        #10;
        rinse_done = 1;

        #10;
        rinse_done = 0;

        // Spin
        #10;
        spin_done = 1;

        #10;
        spin_done = 0;

        // Wait for completion
        #20;

        $finish;

    end

endmodule