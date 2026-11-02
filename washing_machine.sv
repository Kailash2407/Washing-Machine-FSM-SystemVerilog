module washing_machine (

    input logic clk,
    input logic rst,
    input logic start,
    input logic door_closed,

    input logic water_full,
    input logic wash_done,
    input logic tub_empty,
    input logic rinse_done,
    input logic spin_done,

    output logic inlet_valve,
    output logic wash_motor,
    output logic drain_pump,
    output logic spin_motor,
    output logic done
);

    // State Declaration
    typedef enum logic [2:0] {
        IDLE,
        FILL,
        WASH,
        DRAIN,
        RINSE,
        SPIN,
        DONE
    } state_t;

    state_t current_state, next_state;


    // State Register
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end


    // Next State Logic
    always_comb begin

        next_state = current_state;

        case (current_state)

            IDLE: begin
                if (start && door_closed)
                    next_state = FILL;
            end

            FILL: begin
                if (water_full)
                    next_state = WASH;
            end

            WASH: begin
                if (wash_done)
                    next_state = DRAIN;
            end

            DRAIN: begin
                if (tub_empty)
                    next_state = RINSE;
            end

            RINSE: begin
                if (rinse_done)
                    next_state = SPIN;
            end

            SPIN: begin
                if (spin_done)
                    next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end


    // Output Logic (Moore FSM)
    always_comb begin

        // Default Outputs
        inlet_valve = 0;
        wash_motor  = 0;
        drain_pump  = 0;
        spin_motor  = 0;
        done        = 0;

        case (current_state)

            IDLE: begin
                // All outputs OFF
            end

            FILL: begin
                inlet_valve = 1;
            end

            WASH: begin
                wash_motor = 1;
            end

            DRAIN: begin
                drain_pump = 1;
            end

            RINSE: begin
                inlet_valve = 1;
                wash_motor  = 1;
            end

            SPIN: begin
                spin_motor = 1;
            end

            DONE: begin
                done = 1;
            end

            default: begin
                // All outputs OFF
            end

        endcase

    end

endmodule