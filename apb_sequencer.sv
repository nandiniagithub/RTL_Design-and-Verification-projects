//APB sequencer class
class apb_sequencer extends uvm_sequencer #(apb_xtn);

//Factory registration
	`uvm_component_utils(apb_sequencer)

//Function new constructor
	function new(string name="apb_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction
endclass
	

