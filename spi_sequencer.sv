//spi sequencer class
class spi_sequencer extends uvm_sequencer #(spi_xtn);

//Factory registration
	`uvm_component_utils(spi_sequencer)

//Function new constructor
	function new(string name="spi_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction
endclass

