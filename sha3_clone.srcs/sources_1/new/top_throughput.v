`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 06:21:09 AM
// Design Name: 
// Module Name: top_throughput
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

`define CYCLE_CACHE 100
module top_throughput(
    input CLK100MHZ,
    input CPU_RESETN,
    output UART_RXD_OUT,
    output reg [0:0] LED
    );
    reg [27:0] clk_cnt;
    reg [31:0] cycle_cnt;
    wire clk = CLK100MHZ, rst_n = CPU_RESETN, UART_TXD = UART_RXD_OUT;
    wire clk_400;
    
//    reg cs, we;
//    reg [7:0] address;
//    reg [31:0] write_data, read_data;
//    sha3_wrapper sha3_wrapper_ins(
//       .clk(clk),
//       .rst_n(rst_n),
//       .cs(cs),
//       .we(we),
//       .address(address),
//       .write_data(write_data),
//       .read_data(read_data)
//    );
//    UART_TX_CTRL UART_TX_CTRL_ins(
//       .SEND(),
//       .DATA(),
//       .CLK(),
//       .READY(),
//       .UART_TX(UART_TXD)
//    );

    reg [31:0] cycle_cache[`CYCLE_CACHE-1:0];
    
    always @(posedge clk_400)
    begin
        clk_cnt <= clk_cnt + 1;
    end
    
    always @(posedge clk_cnt[26])
    begin
        LED[0] <= ~LED[0];
    end
    
    
    clk_wiz_0 clk_wiz_0_ins (
      // Clock out ports
      .clk_out1(clk_400),
      // Status and control signals
      .reset(),
      .locked(),
     // Clock in ports
      .clk_in1(CLK100MHZ)
     );
endmodule
