`timescale 1ns / 1ps

module smart_home_automation_tb();

    // Testbench Signals
    reg clk;
    reg rst;
    reg motion_sensor;
    reg temp_sensor;
    reg light_sensor;
    reg manual_override;
    wire light_control;
    wire fan_control;
    wire security_alarm;

    // Instantiate the Design Under Test (DUT)
    smart_home_automation uut (
        .clk(clk),
        .rst(rst),
        .motion_sensor(motion_sensor),
        .temp_sensor(temp_sensor),
        .light_sensor(light_sensor),
        .manual_override(manual_override),
        .light_control(light_control),
        .fan_control(fan_control),
        .security_alarm(security_alarm)
    );

    // Clock Generation
    always #5 clk = ~clk; // 100MHz clock simulation

    // Initial Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        motion_sensor = 0;
        temp_sensor = 0;
        light_sensor = 0;
        manual_override = 0;
        
        // Reset system
        #10 rst = 0;

        // Test 1: Manual override on
        manual_override = 1;
        #10;
        $display("Test 1 - Manual Override: Light = %b", light_control);

        // Test 2: Motion detected in darkness
        manual_override = 0;
        motion_sensor = 1; // Motion detected
        light_sensor = 1;  // Bright conditions (light shouldn't turn on)
        #10;
        $display("Test 2 - Motion in Bright Conditions: Light = %b", light_control);

        light_sensor = 0;  // Dark conditions (light should turn on)
        #10;
        $display("Test 3 - Motion in Dark Conditions: Light = %b", light_control);

        // Test 3: Temperature control
        temp_sensor = 29; // Below threshold (fan off)
        #10;
        $display("Test 4 - Low Temperature: Fan = %b", fan_control);

        temp_sensor = 31; // Above threshold (fan on)
        #10;
        $display("Test 5 - High Temperature: Fan = %b", fan_control);

        // Test 4: Security alarm scenarios
        motion_sensor = 1; // Motion detected with no manual override
        manual_override = 0;
        #10;
        $display("Test 6 - Security Alarm Triggered: Alarm = %b", security_alarm);

        manual_override = 1; // Alarm should deactivate
        #10;
        $display("Test 7 - Alarm Deactivated via Manual Override: Alarm = %b", security_alarm);

        // End simulation
        #20;
        $finish;
    end
initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
end
endmodule
