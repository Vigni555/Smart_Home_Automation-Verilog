`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 20:10:32
// Design Name: 
// Module Name: UART_Transmitter
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


module UART_Transmitter(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg busy
);

parameter CLOCK_FREQ = 50000000; // 50 MHz clock
parameter BAUD_RATE = 9600;
parameter TICKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

// Internal signals
reg [3:0] bit_index;
reg [9:0] shift_reg;  // Start bit + 8 data bits + Stop bit
reg [15:0] tick_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;
        busy <= 0;
        bit_index <= 0;
        tick_counter <= 0;
    end 
    else if (tx_start && !busy) begin
        busy <= 1;
        shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit (0), Data, Stop bit (1)
        bit_index <= 0;
        tick_counter <= 0;
    end 
    else if (busy) begin
        if (tick_counter == TICKS_PER_BIT) begin
            tx <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_index <= bit_index + 1;
            tick_counter <= 0;
            
            if (bit_index == 9) // Completed 1 Start + 8 Data + 1 Stop bits
                busy <= 0;
        end 
        else begin
            tick_counter <= tick_counter + 1;
        end
    end
end
endmodule
