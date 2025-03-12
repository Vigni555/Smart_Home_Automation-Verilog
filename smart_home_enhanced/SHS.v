`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 09:51:07
// Design Name: 
// Module Name: SHS
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
module SHS(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,     // Changed from binary to 8-bit
    input wire light_sensor,
    input wire motion_sensor,
    input wire gas_sensor,
    input wire door_sensor,
    input wire rain_sensor,
    output reg fan,
    output reg ac,
    output reg room_light,
    output reg security_alarm,
    output reg exhaust_fan,
    output reg door_lock,
    output reg window_closer
);

// Temperature thresholds
parameter FAN_TEMP_THRESHOLD = 25;
parameter AC_TEMP_THRESHOLD  = 28;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fan <= 0;
        ac <= 0;
        room_light <= 0;
        security_alarm <= 0;
        exhaust_fan <= 0;
        door_lock <= 0;
        window_closer <= 0;
    end else begin
        // Temperature control: Fan & AC
        if (temperature > FAN_TEMP_THRESHOLD)
            fan <= 1;
        else
            fan <= 0;

        if (temperature > AC_TEMP_THRESHOLD)
            ac <= 1;
        else
            ac <= 0;

        // Light sensor: If dark, turn on the room light
        if (!light_sensor)
            room_light <= 1;
        else
            room_light <= 0;

        // Motion sensor: Turn on security alarm if motion detected
        if (motion_sensor)
            security_alarm <= 1;
        else
            security_alarm <= 0;

        // Gas sensor: Turn on exhaust fan if gas detected
        if (gas_sensor)
            exhaust_fan <= 1;
        else
            exhaust_fan <= 0;

        // Door sensor: Lock the door if open
        if (door_sensor)
            door_lock <= 1;
        else
            door_lock <= 0;

        // Rain sensor: Close the window if rain detected
        if (rain_sensor)
            window_closer <= 1;
        else
            window_closer <= 0;
    end
end

endmodule
