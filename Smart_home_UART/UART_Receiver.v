`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 20:11:33
// Design Name: 
// Module Name: UART_Receiver
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


module UART_Receiver (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid
);

parameter CLOCK_FREQ = 50000000; // 50 MHz clock
parameter BAUD_RATE = 9600;
parameter TICKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

// Internal signals
reg [3:0] bit_index;
reg [7:0] buffer;
reg [15:0] tick_counter;
reg receiving;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_valid <= 0;
        receiving <= 0;
        tick_counter <= 0;
        bit_index <= 0;
    end 
    else if (!receiving && !rx) begin
        receiving <= 1;
        tick_counter <= TICKS_PER_BIT / 2; // Sample at center of the start bit
        bit_index <= 0;
    end 
    else if (receiving) begin
        if (tick_counter == TICKS_PER_BIT) begin
            buffer[bit_index] <= rx;
            bit_index <= bit_index + 1;
            tick_counter <= 0;

            if (bit_index == 8) begin
                data_out <= buffer;
                data_valid <= 1;
                receiving <= 0;
            end
        end 
        else begin
            tick_counter <= tick_counter + 1;
        end
    end 
    else begin
        data_valid <= 0;
    end
end
endmodule
