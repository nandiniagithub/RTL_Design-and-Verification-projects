//env configuration class
class env_cfg extends uvm_object;

//Factory registration
	`uvm_object_utils(env_cfg)

	bit has_scoreboard = 0;
	bit has_apb_agent = 1;
	bit has_spi_agent = 1;
	bit has_virtual_sequencer = 1;
	bit has_functional_coverage = 1;
	int no_of_agents = 1;
	apb_cfg a_cfg[];
	spi_cfg s_cfg[];

	spi_apb_reg_block reg_block;

//Function new constructor	
function new(string name="env_cfg");
	super.new(name);
endfunction
endclass

