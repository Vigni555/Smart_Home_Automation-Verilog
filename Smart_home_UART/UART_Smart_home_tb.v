`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2025 11:36:27
// Design Name: 
// Module Name: UART_Smart_home_tb
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


module UART_Smart_home_tb;

    // Inputs
    reg clk;
    reg rst;
    reg rx;

    // Outputs
    wire tx;
    wire [7:0] data_out;
    wire light_control;
    wire fan_control;
    wire alarm_control;

    // Instantiate the Unit Under Test (UUT)
    UART_Controller uut (
        .clk(clk), 
        .rst(rst), 
        .rx(rx), 
        .tx(tx), 
        .data_out(data_out), 
        .light_control(light_control), 
        .fan_control(fan_control), 
        .alarm_control(alarm_control)
    );

    // Clock generation
    always begin
        #10 clk = ~clk; // Clock period of 20ns, which gives a frequency of 50 MHz
    end

    // Stimulus block
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        rx = 1; // Idle state (high) for UART RX

        // Apply reset
        rst = 1; 
        #20;  // Wait for some time
        rst = 0;

        // Test case 1: Send 'L' (light on command)
        #50; 
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'L' = 0x4C
        #10 rx = 0; // Data bit 1
        #10 rx = 1; // Data bit 2
        #10 rx = 0; // Data bit 3
        #10 rx = 1; // Data bit 4
        #10 rx = 1; // Data bit 5
        #10 rx = 0; // Data bit 6
        #10 rx = 1; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response
        
        // Test case 2: Send 'F' (fan on command)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'F' = 0x46
        #10 rx = 0; // Data bit 1
        #10 rx = 0; // Data bit 2
        #10 rx = 1; // Data bit 3
        #10 rx = 0; // Data bit 4
        #10 rx = 1; // Data bit 5
        #10 rx = 1; // Data bit 6
        #10 rx = 0; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response

        // Test case 3: Send 'A' (alarm on command)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'A' = 0x41
        #10 rx = 0; // Data bit 1
        #10 rx = 0; // Data bit 2
        #10 rx = 0; // Data bit 3
        #10 rx = 0; // Data bit 4
        #10 rx = 0; // Data bit 5
        #10 rx = 0; // Data bit 6
        #10 rx = 1; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response

        // Test case 4: Send 'l' (light off command)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'l' = 0x6C
        #10 rx = 0; // Data bit 1
        #10 rx = 1; // Data bit 2
        #10 rx = 1; // Data bit 3
        #10 rx = 0; // Data bit 4
        #10 rx = 1; // Data bit 5
        #10 rx = 1; // Data bit 6
        #10 rx = 0; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response

        // Test case 5: Send 'f' (fan off command)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'f' = 0x66
        #10 rx = 0; // Data bit 1
        #10 rx = 0; // Data bit 2
        #10 rx = 0; // Data bit 3
        #10 rx = 1; // Data bit 4
        #10 rx = 1; // Data bit 5
        #10 rx = 0; // Data bit 6
        #10 rx = 1; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response

        // Test case 6: Send 'a' (alarm off command)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: 'a' = 0x61
        #10 rx = 0; // Data bit 1
        #10 rx = 0; // Data bit 2
        #10 rx = 0; // Data bit 3
        #10 rx = 1; // Data bit 4
        #10 rx = 1; // Data bit 5
        #10 rx = 0; // Data bit 6
        #10 rx = 1; // Data bit 7
        #10 rx = 1; // Stop bit
        #50;  // Wait for response

        // Test case 7: Send invalid command (0x99)
        #50;
        rx = 0;  // Start bit
        #10 rx = 1; // Data bit 0: '0x99'
        #10 rx = 0; // Data bit 1
        #10 rx = 0; // Data bit 2
        #10 rx = 0; // Data bit 3
        #10 rx = 1; // Data bit 4
        #10 rx = 0; // Data bit 5
        #10 rx = 0; // Data bit 6
        #10 rx = 1; // Data bit 7
        #10 rx = 1; // Stop bit
        #1000;  // Wait for response
        
        $finish;

      end

endmodule

