//Top module
module top;
	import spi_apb_test_pkg::* ;
	import uvm_pkg::* ;
	bit clock;

	initial begin
		clock = 1'b0;
		forever #5 clock = ~clock;
	end

//virtual if handle
	spi_if s_vif(clock);
	apb_if a_vif(clock);

//DUT instantiation
	spi_top_module dut (.PCLK(clock), .PRESET_n(a_vif.PRESET_n), .PWRITE_i(a_vif.PWRITE), .PSEL_i(a_vif.PSEL), .PENABLE_i(a_vif.PENABLE), .miso_i(s_vif.miso), .PADDR_i(a_vif.PADDR), .PWDATA_i(a_vif.PWDATA), .ss_o(s_vif.ss), .sclk_o(s_vif.sclk), .PREADY_o(a_vif.PREADY),
		.PSLVERR_o(a_vif.PSLVERR), .mosi_o(s_vif.mosi), .spi_interrupt_request_o(s_vif.spi_interrupt_request), .PRDATA_o(a_vif.PRDATA));


	initial begin
		`ifdef VCS
		$fsdbDumpvars(0, top);
		`endif
		uvm_config_db #(virtual spi_if)::set(null,"*","spi_if",s_vif);
		uvm_config_db #(virtual apb_if)::set(null,"*","apb_if",a_vif);
		run_test();
		end
endmodule

