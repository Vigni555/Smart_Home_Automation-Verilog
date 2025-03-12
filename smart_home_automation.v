// Code your design here
`timescale 1ns / 1ps

module smart_home_automation(
    input wire clk,                // Clock input
    input wire rst,                // Reset input
    input wire motion_sensor,      // Motion sensor input
    input wire temp_sensor,        // Temperature sensor input
    input wire light_sensor,       // Light sensor input (for ambient light detection)
    input wire manual_override,    // Manual switch input
    output reg light_control,      // Light control output
    output reg fan_control,        // Fan control output
    output reg security_alarm      // Security alarm output
);

// Parameters for temperature threshold
parameter TEMP_THRESHOLD = 30; // Example threshold temperature

always @(posedge clk or posedge rst) begin
    if (rst) begin
        light_control <= 1'b0;
        fan_control <= 1'b0;
        security_alarm <= 1'b0;
    end else begin
        // Lighting Control
        if (manual_override)
            light_control <= 1'b1; // Manual switch turns on light
        else if (motion_sensor && !light_sensor)
            light_control <= 1'b1; // Lights on if motion detected in dark conditions
        else
            light_control <= 1'b0;

        // Fan Control (based on temperature threshold)
        if (temp_sensor > TEMP_THRESHOLD)
            fan_control <= 1'b1;
        else
            fan_control <= 1'b0;

        // Security Alarm System
        if (motion_sensor && manual_override == 0)
            security_alarm <= 1'b1; // Alarm triggers if motion is detected without manual override
        else
            security_alarm <= 1'b0;
    end
end

endmodule
