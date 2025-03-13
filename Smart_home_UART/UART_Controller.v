`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 20:08:59
// Design Name: 
// Module Name: UART_Controller
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

module UART_Controller (
   
    input wire clk,            // System clock
    input wire rst,            // System reset
    input wire rx,             // UART receive input
    output wire tx,            // UART transmit output
    output reg [7:0] data_out, // Data received from UART
    output reg light_control,  // Light control output
    output reg fan_control,    // Fan control output
    output reg alarm_control   // Security alarm control output
);

// UART Parameters
parameter BAUD_RATE = 9600;
parameter CLOCK_FREQ = 50000000; // 50 MHz clock
parameter TICKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

// Internal signals
reg [7:0] tx_data;
reg tx_start;
wire tx_busy;
wire [7:0] rx_data;
wire rx_valid;

// Instantiate UART Transmitter and Receiver
UART_Transmitter tx_inst (
    .clk(clk), 
    .rst(rst), 
    .tx_start(tx_start), 
    .tx_data(tx_data), 
    .tx(tx), 
    .busy(tx_busy)
);

UART_Receiver rx_inst (
    .clk(clk), 
    .rst(rst), 
    .rx(rx), 
    .data_out(rx_data), 
    .data_valid(rx_valid)
);

// Control Logic for Smart Home Automation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        light_control <= 0;
        fan_control <= 0;
        alarm_control <= 0;
        data_out <= 8'b0;
        tx_data <= 8'h00;
        tx_start <= 0;
    end 
    else if (rx_valid) begin
        data_out <= rx_data; // Store received data

        // Command Handling with Checksum Validation
        case (rx_data)
            8'hf1: begin 
                light_control <= 1;  // 'L' - Light ON
                tx_data <= 8'h01;   // ACK for Light ON
            end
            8'hf0: begin 
                fan_control <= 1;    // 'F' - Fan ON
                tx_data <= 8'h02;   // ACK for Fan ON
            end
            8'h41: begin 
                alarm_control <= 1;  // 'A' - Alarm ON
                tx_data <= 8'h03;   // ACK for Alarm ON
            end
            8'h6C: begin 
                light_control <= 0;  // 'l' - Light OFF
                tx_data <= 8'h04;   // ACK for Light OFF
            end
            8'h66: begin 
                fan_control <= 0;    // 'f' - Fan OFF
                tx_data <= 8'h05;   // ACK for Fan OFF
            end
            8'h61: begin 
                alarm_control <= 0;  // 'a' - Alarm OFF
                tx_data <= 8'h06;   // ACK for Alarm OFF
            end
            default: begin
                // Error Feedback for Invalid Command
                tx_data <= 8'hE0;   // Error: Unknown Command
            end
        endcase
        tx_start <= 1; // Trigger TX to send the response
    end 
    else if (tx_start && !tx_busy) begin
        tx_start <= 0; // Ensure TX is ready for new data
    end
end

endmodule
module UART_Transmitter (
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
      	buffer <= 8'b0;
    end 
    else if (!receiving ) begin
        receiving <= 1;
        tick_counter <= TICKS_PER_BIT / 2; // Sample at center of the start bit
        bit_index <= 0;
    end 
    else if (receiving) begin
       
            buffer[bit_index] <= rx;
            bit_index <= bit_index + 1;
            tick_counter <= 0;

            if (bit_index == 8) begin
                data_out <= buffer;
                data_valid <= 1;
                receiving <= 0;
            
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
