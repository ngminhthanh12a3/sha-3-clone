`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 05:06:25 PM
// Design Name: 
// Module Name: top_freq_test
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

module top_freq_test(
    input CLK100MHZ,
    input CPU_RESETN,
    output [3:0] LED
    );
    
    wire clk = CLK100MHZ;
    
//    clk_wiz_0 clk_wiz_0_ins (
//      // Clock out ports
//      .clk_out1(clk),
//      // Status and control signals
//      .reset(),
//      .locked(),
//     // Clock in ports
//      .clk_in1(CLK100MHZ)
//     );
     
    //----------------------------------------------------------------
	// Hashes of empty messages
	//----------------------------------------------------------------
	localparam	[511:0]	SHA3_224_EMPTY_MSG =
		{	224'h6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7,
			{512-224{1'bX}}};

	localparam	[511:0]	SHA3_256_EMPTY_MSG =
		{	256'ha7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a,
			{512-256{1'bX}}};
			
	localparam	[511:0]	SHA3_384_EMPTY_MSG =
		{	384'h0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004,
			{512-384{1'bX}}};

	localparam	[511:0]	SHA3_512_EMPTY_MSG =
		{	512'ha69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26};

	/*
		 * Sponge Parameters
		 *
		 */
	`define SHA3_224_BLOCK_BITS	1152
	`define SHA3_256_BLOCK_BITS	1088
	`define SHA3_384_BLOCK_BITS	 832
	`define SHA3_512_BLOCK_BITS	 576

	`define SHA3_224_OUTPUT_BITS	 224
	`define SHA3_256_OUTPUT_BITS	 256
	`define SHA3_384_OUTPUT_BITS	 384
	`define SHA3_512_OUTPUT_BITS	 512
    
    //
    freq_test_part_empty #(
        `SHA3_512_OUTPUT_BITS,
        `SHA3_512_BLOCK_BITS
        )
        freq_test_part_empty_ins2 (
        .CLK100MHZ(CLK100MHZ),
        .CPU_RESETN(CPU_RESETN),
        
        .clk(clk),
        
        .correct_hash(SHA3_512_EMPTY_MSG),
        
        .LED(LED[0])
    );
    endmodule
