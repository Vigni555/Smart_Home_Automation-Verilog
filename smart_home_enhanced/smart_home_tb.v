`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 10:41:38
// Design Name: 
// Module Name: smart_home_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module smart_home_tb(// Inputs
    reg clk;
    reg reset;
    reg [7:0] temperature;
    reg light_sensor;
    reg motion_sensor;
    reg gas_sensor;
    reg door_sensor;
    reg rain_sensor;

    // Outputs
    wire fan;
    wire ac;
    wire room_light;
    wire security_alarm;
    wire exhaust_fan;
    wire door_lock;
    wire window_closer;

    // Instantiate the module
    SHS uut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .light_sensor(light_sensor),
        .motion_sensor(motion_sensor),
        .gas_sensor(gas_sensor),
        .door_sensor(door_sensor),
        .rain_sensor(rain_sensor),
        .fan(fan),
        .ac(ac),
        .room_light(room_light),
        .security_alarm(security_alarm),
        .exhaust_fan(exhaust_fan),
        .door_lock(door_lock),
        .window_closer(window_closer)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        temperature = 8'd0;
        light_sensor = 1;
        motion_sensor = 0;
        gas_sensor = 0;
        door_sensor = 0;
        rain_sensor = 0;

        // Reset Pulse
        #10 reset = 0;

        // Test: Temperature controls
        #10 temperature = 8'd26;  // Fan should turn ON
        #10 temperature = 8'd29;  // AC should turn ON
        #10 temperature = 8'd24;  // Both OFF

        // Test: Light Sensor
        #10 light_sensor = 0;     // Room light ON
        #10 light_sensor = 1;     // Room light OFF

        // Test: Motion Sensor (Security Alarm)
        #10 motion_sensor = 1;    // Alarm ON
        #10 motion_sensor = 0;    // Alarm OFF

        // Test: Gas Sensor (Exhaust Fan)
        #10 gas_sensor = 1;       // Exhaust Fan ON
        #10 gas_sensor = 0;       // Exhaust Fan OFF

        // Test: Door Sensor (Door Lock)
        #10 door_sensor = 1;      // Door Lock ON
        #10 door_sensor = 0;      // Door Lock OFF

        // Test: Rain Sensor (Window Closer)
        #10 rain_sensor = 1;      // Window Closer ON
        #10 rain_sensor = 0;      // Window Closer OFF

        // Finish simulation
        #20;
        $display("Testbench completed successfully.");
        $finish;
    end
  
 
endmodule
