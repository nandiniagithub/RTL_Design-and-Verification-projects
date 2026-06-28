//spi virtual sequencer class
class spi_apb_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);

//Factory registration
	`uvm_component_utils(spi_apb_virtual_sequencer);

	apb_sequencer a_sqrh[];
	spi_sequencer s_sqrh[];
	env_cfg e_cfg;

//Function new constructor
	function new(string name="spi_apb_virtual_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);

		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal(get_type_name(),"Error in getting configuration")

		a_sqrh = new[e_cfg.no_of_agents];
		s_sqrh = new[e_cfg.no_of_agents];
	endfunction
		
endclass

