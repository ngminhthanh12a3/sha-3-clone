`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 02:28:26 PM
// Design Name: 
// Module Name: tb_freq_sim
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


module tb_freq_sim(

    );
    //----------------------------------------------------------------
	// Internal constant and parameter definitions.
	//----------------------------------------------------------------
	parameter CLK_HALF_PERIOD = 2;
	
	//----------------------------------------------------------------
	// clk_gen
	//
	// Clock generator process.
	//----------------------------------------------------------------
	reg tb_clk, tb_rst_n;
	
	top_freq_test dut(
	    .CLK100MHZ(tb_clk),
        .CPU_RESETN(tb_rst_n),
        .LED()
	);
	
	always
		begin : clk_gen
			#CLK_HALF_PERIOD tb_clk = ~tb_clk;
		end // clk_gen
	
	//----------------------------------------------------------------
	// init_sim()
	//
	// Initialize all counters and testbed functionality as well
	// as setting the DUT inputs to defined values.
	//----------------------------------------------------------------
	task init_sim;
		begin
			tb_clk		= 0;
		end
	endtask // init_sim()
	//----------------------------------------------------------------
	// reset_dut()
	//
	// Toggles reset to force the DUT into a well defined state.
	//----------------------------------------------------------------
	task reset_dut;
		begin
			$display("*** Toggling reset...");
			tb_rst_n = 0;
			#(4 * CLK_HALF_PERIOD);
			tb_rst_n = 1;
		end
	endtask // reset_dut()
	
	
	
	initial
  
    begin : top_freq_test
      $display("*** Testbench for top_freq_test.v started.");


      init_sim();
      reset_dut();
    end
endmodule
