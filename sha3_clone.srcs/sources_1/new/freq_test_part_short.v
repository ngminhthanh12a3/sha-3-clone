//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 04:44:46 PM
// Design Name: 
// Module Name: freq_test_part
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


module freq_test_part_short # (
    parameter [31:0] output_size = 'b0,
    parameter [31:0] block_size = 'b0
    ) (
    input CLK100MHZ,
    input CPU_RESETN,
    
    input clk,
    
    input [511:0] correct_hash,
//    input [31:0] block_size,
//    input [31:0] output_size,
    
    output [0:0] LED
    );
    
    //----------------------------------------------------------------
	// Hashes of empty messages
	//----------------------------------------------------------------
//	localparam	[511:0]	SHA3_224_EMPTY_MSG =
//		{	224'h6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7,
//			{512-224{1'bX}}};
	
    localparam [31:0] block_words = block_size >> 'd5;
    localparam [31:0] output_words = output_size >> 'd5;
    
//    wire clk;// = CLK100MHZ;
    wire rst_n = CPU_RESETN;
    
    wire tb_rdy;
    
    reg [2:0] sha3_phase;
    reg [2:0] wait_cnt;
    
    localparam SHA3_PHASE_WAIT = 1'b0;
    localparam SHA3_PHASE_INIT = 1'b1;
    localparam SHA3_PHASE_SPONGE_PUMP_INIT = 'd2;
    localparam SHA3_PHASE_WAIT_RESP = 'd3;
    localparam SHA3_PHASE_EVAL = 'd4;
    localparam SHA3_PHASE_EVAL_FINISH = 'd5;
    
//    clk_wiz_0 clk_wiz_0_ins (
//      // Clock out ports
//      .clk_out1(clk),
//      // Status and control signals
//      .reset(),
//      .locked(),
//     // Clock in ports
//      .clk_in1(CLK100MHZ)
//     );
     
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sha3_phase <= SHA3_PHASE_WAIT;
            wait_cnt <= 1'b0;
        end
        else begin
            wait_cnt <= wait_cnt + 1'b1;
            if (wait_cnt >= 4 && sha3_phase == SHA3_PHASE_WAIT)
                sha3_phase <= SHA3_PHASE_INIT;
            else if (sha3_phase == SHA3_PHASE_INIT && wr_data_init_cnt >= 'd50) begin
                sha3_phase <= SHA3_PHASE_SPONGE_PUMP_INIT;
            end
            else if (sha3_phase == SHA3_PHASE_SPONGE_PUMP_INIT && tb_dut_init_cnt >= 'd2 && tb_rdy) begin
                sha3_phase <= SHA3_PHASE_WAIT_RESP;
            end
            else if (sha3_phase == SHA3_PHASE_WAIT_RESP && wr_data_rd_cnt >= output_words) begin
                sha3_phase <= SHA3_PHASE_EVAL;
            end
            else if (sha3_phase == SHA3_PHASE_EVAL && eval_cnt >= output_words) begin
                sha3_phase <= SHA3_PHASE_EVAL_FINISH;
            end
        end
    end
    
    reg [5:0] wr_data_init_cnt;
    
    wire [31:0] tb_rd_data;
    reg	[31:0]	tb_wr_data;
    reg				tb_we;
	reg	[ 6:0]	tb_addr;
	reg				tb_dut_next;
	wire				tb_rdy;
	reg [5:0] wr_data_rd_cnt;
	
	reg [31:0] eval_data[output_words-1:0];
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wr_data_init_cnt <= 1'b0;
            tb_wr_data <= 1'b0;
            tb_addr <= 'bX;
			tb_we <= 0;
			tb_dut_next <= 'b0;
			
			wr_data_rd_cnt <= 'b0;
        end
        else begin
            if (sha3_phase == SHA3_PHASE_INIT) begin
                if(wr_data_init_cnt != 50) begin
                    wr_data_init_cnt <= wr_data_init_cnt + 1'b1;
                    case (wr_data_init_cnt)
                        0:					tb_wr_data <= 32'h61626306;		// ...0001 | 10
                        block_words-1:	tb_wr_data <= 32'h00000080;		//	1000...
                        default:			tb_wr_data <= 32'h00000000;
                    endcase
                    tb_addr <= {1'b0, wr_data_init_cnt[5:0]};	// increment address
                    tb_we <= 1;				// enable writing
                end
                else begin
                    tb_addr <= 'bX;
			        tb_we <= 0;
                end
            end
            else if (sha3_phase >= SHA3_PHASE_WAIT_RESP) begin
                if (wr_data_rd_cnt != output_words) begin
                    wr_data_rd_cnt <= wr_data_rd_cnt + 'b1;
                    
                    tb_addr <= {1'b1, wr_data_rd_cnt[5:0]};	// increment address
                    
                end
                if (wr_data_rd_cnt >= 1) begin
                    eval_data[wr_data_rd_cnt - 1] <= tb_rd_data;
                end
            end
        end
    end
    
    reg tb_dut_init;
    reg [2:0] tb_dut_init_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            tb_dut_init_cnt <= 'b0;
            tb_dut_init <= 'b0;
        end
        else if (sha3_phase == SHA3_PHASE_SPONGE_PUMP_INIT) begin
            if (tb_dut_init_cnt < 'd2 && tb_rdy) begin
                tb_dut_init_cnt <= tb_dut_init_cnt + 'b1;
                tb_dut_init <= !tb_dut_init_cnt[0];
            end
        end
    end
    
    
    reg eval_success;
    reg [block_words-1:0] eval_cnt;
    reg [511:0] hash_shreg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            eval_success <= 'b1;
            eval_cnt <= 'b0;
            hash_shreg <= correct_hash;
        end
        else if (sha3_phase == SHA3_PHASE_EVAL && eval_success) begin
            if (eval_cnt != output_words) begin
                eval_cnt <= eval_cnt + 'b1;
                
                eval_success = (hash_shreg[511-:32] == eval_data[eval_cnt]);
                hash_shreg <= {hash_shreg[511-32:0], {32{1'bX}}};
            end
        end
    end
    
    assign LED[0] = eval_success & (sha3_phase == SHA3_PHASE_EVAL_FINISH);
    //    ----------------------------------------------------------------
    //     Device Under Test.
    //    ----------------------------------------------------------------
    sha3 dut
    (
        .clk		(clk),
        .nreset	(rst_n),
        .w			(tb_we),
        .addr		(tb_addr),
        .din		(tb_wr_data),
        .dout		(tb_rd_data),
        .init		(tb_dut_init),
        .next		(tb_dut_next),
        .ready	(tb_rdy)
    );
endmodule
